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
    
    def setup
      @failures = []
    end

    def automate(script)
      @script = script
    end
    
    def handle_output(line)
      if line =~ /Fail: (.*)/
        @failures << $1
      end
    end

    private

    def compile_and_run_automation_script
      script = Tempfile.new("automation-script").tap do |io|
        io.write @script
        io.close
      end
      
      unless Instruments.run_automation(self.class.application_under_test, script.path, self)
        raise "Instruments exited with error"
      end
    end
    
    def check_for_failures
      if @failures.any?
        flunk @failures.join(", ")
      end
    end
  end
end

module Instruments
  def self.run(template, app_path, env_vars={}, output_handler)
    raise "Invalid app path: #{app_path}" unless (File.exist?(app_path) rescue false)
    
    cmd = "instruments -t #{template} #{app_path}"
    env_vars.each do |key, value|
      cmd << " -e #{key} #{value}"
    end
    
    command = UIAutomation::Command.new(cmd)
    command.execute(output_handler) == 0
  end

  def self.run_automation(app_path, script, results_path = ".", output_handler)
    automation_template = "#{`xcode-select -print-path`.strip}/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate"

    run(automation_template, app_path, {
      "UIASCRIPT" => script,
      "UIARESULTSPATH" => results_path,
      "RESET_ON_SHAKE" => "true"
    }, output_handler)
  end
end