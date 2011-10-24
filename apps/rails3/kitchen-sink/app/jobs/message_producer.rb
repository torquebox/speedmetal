class MessageProducer
  def run
    msg = "from MessageProducer(#{Time.now})"
    puts "MessageProducer: publishing #{msg}"
    TorqueBox::Messaging::Queue.new("/queues/a-kitchen-sink-queue").publish(msg)
  end
end
