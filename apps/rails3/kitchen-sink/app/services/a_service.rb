class AService
  def start
    # puts "AService STARTING"
    Thread.new { run }
  end

  def stop
    # puts "AService STOPPING"
    @done = true
  end

  def run
    until @done
      # puts "AService: calling AModel#create_message"
      TorqueBox.transaction {
        AModel.new.create_message
      }
      sleep(0.1)
    end
  end
end
