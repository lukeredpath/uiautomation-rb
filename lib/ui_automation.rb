require 'singleton'

module UIAutomation
  autoload :TestCase,                 "ui_automation/test_case"
  autoload :InstrumentsRunner,        "ui_automation/instruments_runner"
  autoload :Command,                  "ui_automation/command"
  autoload :AutomationTest,           "ui_automation/automation_test"
  autoload :AutomationCommandBuilder, "ui_automation/automation_command_builder"
  autoload :JSLint,                   "ui_automation/js_lint"
  
  def self.configure(&block)
    yield Configuration.instance
  end
  
  def self.bundled_automation_template_path
    support_directory + "Automation.tracetemplate"
  end
  
  def self.support_directory
    Pathname.new(File.dirname(__FILE__)) + ".." + "support"
  end
  
  class ConfigurationError < StandardError
  end
  
  class Configuration
    include Singleton
    attr_accessor :automation_template_path
    
    def automation_template_path=(template_path)
      unless File.exist?(template_path)
        raise ConfigurationError, "Supplied automation template does not exist: #{template_path}" 
      end
      
      @automation_template_path = template_path
    end
  end
end

UIAutomation.configure do |config|
  config.automation_template_path = UIAutomation.bundled_automation_template_path
end
