class AnotherTopicProcessor < TorqueBox::Messaging::MessageProcessor
  def on_message(body)
    puts "#{self.class.name}: PROCESSING #{body}"
  end
end
