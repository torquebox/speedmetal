require 'pathname'
require 'cgi'

class StatsService
  include TorqueBox::Injectors

  def initialize(options={})
    @sample_period = options['sample_period']
    @output_directory = Pathname.new(options['output_directory']).expand_path(Rails.root)
    @queue_counters = options['queues'].map do |q|
      QueueCounter.new(queue_control(q), @sample_period, @output_directory)
    end
  end

  def start
    enable_message_counters
    Thread.new { run }
  end

  def stop
    @done = true
  end

  protected

  def run
    sample_seconds = @sample_period / 1000
    until @done
      @queue_counters.each { |counter| counter.update }
      sleep(@sample_period / 1000 * 0.5) # ensure we never miss an update
    end
  rescue Exception => ex
    puts ex.inspect
    puts ex.backtrace
  end

  def enable_message_counters
    server_control = hornetq_server.hornet_qserver_control
    server_control.message_counter_max_day_count = 1
    server_control.message_counter_sample_period = @sample_period
    server_control.enable_message_counters
  end

  def queue_control(name)
    management_service = hornetq_server.management_service
    management_service.getResource("jms.queue.#{name}")
  end

  def hornetq_server
    @hornetq_server ||= inject('jboss.messaging.default')
  end
end
