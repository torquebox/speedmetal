require 'fileutils'
require 'time'

java_import org.hornetq.api.core.management.MessageCounterInfo

class QueueCounter
  def initialize(queue_control, sample_period, output_directory)
    @queue_control = queue_control
    @sample_period = sample_period
    @output_directory = output_directory
    FileUtils.mkdir_p(@output_directory)
    @last_stat = nil
    @first_update = nil
    Struct.new('QueueStat', :sample_period, :message_count, :message_delta,
                            :queue_size, :queue_delta, :messages_processed,
                            :last_message_added, :last_update, :elapsed_seconds)
  end

  def update
    sample_seconds = @sample_period / 1000
    counter = MessageCounterInfo.from_json(@queue_control.list_message_counter)
    update_time = Time.parse(counter.udpate_timestamp)
     # sometimes we get a bogus first update from 1969
    return unless update_time > Time.parse("01/01/2011")
    @first_update ||= update_time
    if @last_stat.nil? || @last_stat.last_update != update_time
      # HornetQ's depth_delta seems to be off
      delta_queue_size = counter.depth - (@last_stat.nil? ? 0 : @last_stat.queue_size)
      stat = Struct::QueueStat.new
      stat.sample_period = @sample_period
      stat.message_count = counter.count
      stat.message_delta = counter.count_delta
      stat.queue_size = counter.depth
      stat.queue_delta = delta_queue_size
      stat.messages_processed = counter.count_delta - delta_queue_size
      stat.last_message_added = Time.parse(counter.last_add_timestamp)
      stat.last_update = update_time
      stat.elapsed_seconds = (update_time - @first_update).to_i
      @last_stat = stat
      write_stat(stat)
    end
  end

  def name
    @queue_control.name
  end

  def write_stat(stat)
    filename = File.join(@output_directory, CGI.escape(name))
    File.open(filename, 'a') do |file|
      file.write("#{stat.elapsed_seconds} #{stat.message_count} #{stat.message_delta} #{stat.queue_size} #{stat.queue_delta} #{stat.messages_processed}\n")
    end
  end
end
