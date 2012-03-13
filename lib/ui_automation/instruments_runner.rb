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
      if @command.execute(self) > 0
        notify :test_runner_finished_with_error
      else
        notify :test_runner_finished
      end
    end
    
    def handle_output(line)
      case line
      when /Start: (.*)/
        notify :test_started, $1
      when /Pass:/
        notify :test_passed
      when /Fail: (.*)/
        notify :test_failed, $1
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
