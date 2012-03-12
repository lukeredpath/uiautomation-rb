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
        end
      end
    end

    def automate(script)
      @script = script
    end

    private

    def compile_and_run_automation_script
      script = Tempfile.new("automation-script").tap do |io|
        io.write @script
        io.close
      end
      
      unless Instruments.run_automation(self.class.application_under_test, script.path)
        raise "Instruments exited with error"
      end
    end
  end
end

module Instruments
  def self.run(template, app_path, env_vars={})
    raise "Invalid app path: #{app_path}" unless (File.exist?(app_path) rescue false)
    
    cmd = "instruments -t #{template} #{app_path} > /dev/null"
    env_vars.each do |key, value|
      cmd << " -e #{key} #{value}"
    end
    
    system cmd
  end

  def self.run_automation(app_path, script, results_path = ".")
    automation_template = "#{`xcode-select -print-path`.strip}/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate"

    run(automation_template, app_path, {
      "UIASCRIPT" => script,
      "UIARESULTSPATH" => results_path,
      "RESET_ON_SHAKE" => "true"
    })
  end
end
