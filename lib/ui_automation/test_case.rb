require 'minitest/unit'
require 'tempfile'

module UIAutomation
  class TestCase < ::MiniTest::Unit::TestCase
    class << self
      attr_accessor :application_under_test
      
      def test(&block)
        define_method(:test_automation) do
          instance_eval(&block)
          compile_and_run_automation_script
          check_for_failures
        end
      end
    end

    def automate(script)
      @script = <<-JS
        UIALogger.logStart('anything')
        #{script}
      JS
    end

    private

    def compile_and_run_automation_script
      script = Tempfile.new("automation-script").tap do |io|
        io.write @script
        io.close
      end
      
      command_builder.script_path = script.path
      
      instruments = InstrumentsRunner.new(command_builder.build)
      instruments.add_listener(@automation_test = AutomationTest.new)
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
  end
end
