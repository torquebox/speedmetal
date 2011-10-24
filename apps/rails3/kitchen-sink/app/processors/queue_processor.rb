class QueueProcessor < TorqueBox::Messaging::MessageProcessor
  def on_message(body)
    puts "#{self.class.name}: PROCESSING #{body}"
    TorqueBox::Messaging::Topic.new("/topics/a-kitchen-sink-topic").publish("#{body}:#{self.class.name}(#{Time.now})")
  end
end
