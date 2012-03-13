module UIAutomation
  class AutomationCommandBuilder
    attr_accessor :app_path, :script_path
    
    def initialize(template_path)
      @template_path = template_path
    end
    
    def build
      raise "App path was not specified" unless app_path
      raise "Script path was not specified" unless script_path
      
      command_line = "instruments -t #{@template_path} #{@app_path} -e UIASCRIPT #{script_path}"
      Command.new(command_line.strip)
    end
  end
end
