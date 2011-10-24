class MessageProducerTask < TorqueBox::Messaging::Task

  def create_message(payload={ })
    msg = "from MessageProducerTask(#{Time.now})"
    puts "MessageProducerTask: publishing #{msg}"
    TorqueBox::Messaging::Queue.new("/queues/a-kitchen-sink-queue").publish(msg)
  end
end
