require 'minitest/unit'
require 'tempfile'

module UIAutomation
  class TestCase < ::MiniTest::Unit::TestCase
    class << self
      attr_accessor :application_under_test
      
      def test(name = "", &block)
        define_method(:test_automation) do
          initialize_test(&block)
          compile_and_run_automation_script
          check_for_failures
        end
      end
      
      def tests_application(app)
        self.application_under_test = app
      end
    end
    
    attr_reader :automation_test

    private
    
    def initialize_test(&block)
      @automation_test = AutomationTest.new(&block)
    end

    def compile_and_run_automation_script
      script = Tempfile.new("automation-script").tap do |io|
        io.write automation_test.compile
        io.close
      end
      
      command_builder.script_path = script.path
      
      instruments = InstrumentsRunner.new(command_builder.build)
      instruments.add_listener(TestCleaner.new)
      instruments.add_listener(automation_test)
      instruments.run
    end
    
    def check_for_failures
      assert @automation_test.passed?, @automation_test.failure_message
    end
    
    def command_builder
      @command_builder ||= AutomationCommandBuilder.new(template_path).tap do |builder|
        builder.app_path = self.class.application_under_test
      end
    end
    
    def template_path
      UIAutomation::Configuration.instance.automation_template_path
    end
    
    class TestCleaner
      def test_runner_finished
        cleanup
      end

      def test_runner_finished_with_error
        cleanup
      end
      
      def cleanup
        system "rm -fr #{FileUtils.pwd}/*.trace"
        system "rm -fr #{FileUtils.pwd}/Run*"
      end
    end
  end
end
