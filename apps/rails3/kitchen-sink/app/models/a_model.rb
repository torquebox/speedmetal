class AModel
  include TorqueBox::Messaging::Backgroundable
  
  def create_message
    puts "AModel#create_message - SLEEPING"
    sleep(5)
    msg = "from AModel#create_message(#{Time.now})"
    puts "AModel: publishing #{msg}"
    TorqueBox::Messaging::Queue.new("/queues/a-kitchen-sink-queue").publish(msg)
  end

  always_background :create_message
end
