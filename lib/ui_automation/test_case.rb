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
      
      automation_command = Instruments.automation_command(self.class.application_under_test, script.path)

      instruments = InstrumentsRunner.new(automation_command)
      instruments.add_listener(@automation_test = AutomationTest.new)
      instruments.run
    end
    
    def check_for_failures
      assert @automation_test.passed?, @automation_test.failure_message
    end
  end
end

module Instruments
  def self.command_for(template, app_path, env_vars={})
    raise "Invalid app path: #{app_path}" unless (File.exist?(app_path) rescue false)
    
    cmd = "instruments -t #{template} #{app_path}"
    env_vars.each do |key, value|
      cmd << " -e #{key} #{value}"
    end
    
    UIAutomation::Command.new(cmd)
  end

  def self.automation_command(app_path, script, results_path = ".")
    automation_template = "#{`xcode-select -print-path`.strip}/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate"

    command_for(automation_template, app_path, {
      "UIASCRIPT" => script,
      "UIARESULTSPATH" => results_path
    })
  end
end
