module UIAutomation
  class InstrumentsRunner
    def initialize(command)
      @command = command
      @listeners = []
    end
    
    def add_listener(listener)
      @listeners << listener
    end
    
    def run
      @command.execute(self)
    end
    
    def handle_output(line)
      case line
      when /Start:/
        notify :test_started
      when /Pass:/
        notify :test_passed
      when /Fail:/
        notify :test_failed
      when /Issue:/
        notify :test_aborted
      end
    end
    
    private
    
    def notify(message, *args)
      @listeners.each { |l| l.send(message, *args) }
    end
  end
end
