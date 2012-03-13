require 'spec_helper'

describe UIAutomation::InstrumentsRunner do
  let(:command)       { mock('command') }
  let(:listener)      { mock('listener').as_null_object }
  let(:instruments)   { UIAutomation::InstrumentsRunner.new(command) }
  
  before do
    instruments.add_listener(listener)
  end
  
  it "executes it's command with itself as the output handler" do
    command.should_receive(:execute).with(instruments).and_return(0)
    instruments.run
  end
  
  it "notifies that it finished if the command returns a zero exit code" do
    command.stub(:execute).and_return(0)
    listener.expects(:test_runner_finished)
    instruments.run
  end
  
  it "notifies that it finished with error if the command returns a non-zero exit code" do
    command.stub(:execute).and_return(1)
    listener.expects(:test_runner_finished_with_error)
    instruments.run
  end
  
  ## SAMPLE OUTPUT
  # 2012-03-12 23:49:15 +0000 Start: End to end functionality: One project exists and is displayed.
  # 2012-03-12 23:49:15 +0000 Start: It started
  # 2012-03-12 23:49:15 +0000 Pass: It passed
  # 2012-03-12 23:49:15 +0000 Start: It started again
  # 2012-03-12 23:49:15 +0000 Issue: Something weird happened
  # 2012-03-12 23:49:15 +0000 Start: Another test
  # 2012-03-12 23:49:15 +0000 Fail: This one failed
  # 2012-03-12 23:49:15 +0000 Start: Just some logging
  # 2012-03-12 23:49:15 +0000 Debug: A debug message
  # 2012-03-12 23:49:15 +0000 Default: A normal message
  # 2012-03-12 23:49:15 +0000 Warning: A warning message
  # 2012-03-12 23:49:15 +0000 Error: An error message
  # 2012-03-12 23:49:15 +0000 Pass: It still passes
  # 2012-03-12 23:49:15 +0000 Debug: target.shake()
  # 2012-03-12 23:49:15 +0000 Pass: Passed
  # Instruments Trace Complete (Duration : 5.500378s; Output : /Users/luke/Code/repos/Timeslips/instrumentscli0.trace)
  
  it "notifies a test began when start log message received" do
    listener.should_receive(:test_started).with("It started")
    instruments.handle_output("2012-03-12 23:49:15 +0000 Start: It started")
  end
  
  it "notifies a test passed when pass log message received" do
    listener.should_receive(:test_passed)
    instruments.handle_output("2012-03-12 23:49:15 +0000 Pass: It passed")
  end
  
  it "notifies a test failed when fail log message received" do
    listener.should_receive(:test_failed).with("This one failed")
    instruments.handle_output("2012-03-12 23:49:15 +0000 Fail: This one failed")
  end
  
  it "notifies a test aborted when issue log message received" do
    listener.should_receive(:test_aborted)
    instruments.handle_output("2012-03-12 23:49:15 +0000 Issue: Something weird happened")
  end
end
