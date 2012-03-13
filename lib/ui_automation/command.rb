module UIAutomation
  class Command
    def initialize(command_line)
      @command_line = command_line
    end
    
    def execute(output_handler)
      IO.popen("#{@command_line} 2>&1") do |io|
        begin
          while line = io.readline
            output_handler.handle_output(line.strip)
          end
        rescue EOFError
        end
      end
      
      $?.exitstatus
    end
    
    def to_s
      @command_line
    end
  end
end
