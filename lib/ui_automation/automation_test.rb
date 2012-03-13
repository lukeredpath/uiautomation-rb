require 'state_machine'

module UIAutomation
  class AutomationTest
    attr_reader :name, :failure_message
    
    state_machine :state, :initial => :waiting do
      event :_start do
        transition :waiting => :running
      end
      
      event :_pass do
        transition :running => :passed
      end
      
      event :_fail do
        transition :running => :failed
      end
      
      event :_abort do
        transition :running => :aborted
      end
      
      event :_finished do
        transition [:waiting, :running] => :passed
      end
      
      event :_finished_with_error do
        transition [:waiting, :running, :passed] => :failed
      end
    end
    
    def test_started(name)
      @name = name
      _start
    end
    
    def test_passed
      _pass
    end
    
    def test_failed(message)
      @failure_message = message
      _fail
    end
    
    def test_aborted
      _abort
    end
    
    def test_runner_finished
      _finished
    end
    
    def test_runner_finished_with_error
      _finished_with_error
    end
  end
end
