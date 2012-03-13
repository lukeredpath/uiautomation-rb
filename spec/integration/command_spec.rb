require 'spec_helper'
require 'tempfile'

describe UIAutomation::Command do
  context "when executing" do
    it "yields each stripped line of STDOUT to its output handler" do
      test_script = test_script_with_contents <<-RUBY
        puts "Line One"
        puts "Line Two"
        puts "Line Three"
      RUBY

      output_handler = mock('listener')
      output_handler.should_receive(:handle_output).with("Line One").ordered
      output_handler.should_receive(:handle_output).with("Line Two").ordered
      output_handler.should_receive(:handle_output).with("Line Three").ordered

      command = UIAutomation::Command.new("ruby #{test_script.path}")
      command.execute(output_handler)
    end

    it "yields each stripped line of STDERR to its output handler" do
      test_script = test_script_with_contents <<-RUBY
        STDERR.puts "Line One"
        STDERR.puts "Line Two"
        STDERR.puts "Line Three"
      RUBY

      output_handler = mock('listener')
      output_handler.should_receive(:handle_output).with("Line One").ordered
      output_handler.should_receive(:handle_output).with("Line Two").ordered
      output_handler.should_receive(:handle_output).with("Line Three").ordered

      command = UIAutomation::Command.new("ruby #{test_script.path}")
      command.execute(output_handler)
    end

    it "returns the exit status of the invoked command" do
      test_script = test_script_with_contents <<-RUBY
        exit(10)
      RUBY
      
      command = UIAutomation::Command.new("ruby #{test_script.path}")
      command.execute(stub).should == 10
    end
  end
  
  private
  
  def test_script_with_contents(string)
    Tempfile.new("test-script").tap do |script|
      script.write(string)
      script.close
    end
  end
end
