class AService
  def start
    puts "AService STARTING"
    Thread.new { run }
  end

  def stop
    puts "AService STOPPING"
    @done = true
  end

  def run
    until @done
      puts "AService: calling AModel#create_message"
      AModel.new.create_message
      sleep(15)
    end
  end
end
