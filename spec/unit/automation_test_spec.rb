require 'spec_helper'

describe UIAutomation::AutomationTest do
  let(:test) { UIAutomation::AutomationTest.new }

  any_string = ""

  it "starts off as waiting" do
    test.should be_waiting
  end

  it "transitions to a running state when a test_started message is received" do
    test.test_started(any_string)
    test.should be_running
  end

  it "transitions from a running state to a passed state when a test_passed message is received" do
    test._start
    test.test_passed
    test.should be_passed
  end

  it "transitions from a running state to a failed state when a test_failed message is received" do
    test._start
    test.test_failed(any_string)
    test.should be_failed
  end

  it "transitions from a running state to an aborted state when a test_aborted message is received" do
    test._start
    test.test_aborted(any_string)
    test.should be_aborted
  end
  
  it "transitions from a waiting state to an aborted state when a test_aborted message is received" do
    test.test_aborted(any_string)
    test.should be_aborted(any_string)
  end

  it "stores the name of the test when it starts" do
    test.test_started("An example test")
    test.name.should == "An example test"
  end

  it "stores the failure message when it fails" do
    test.test_failed("This went wrong")
    test.failure_message.should == "This went wrong"
  end

  context "when the test runner finishes" do
    it "transitions from a waiting state to a passed state" do
      test.test_runner_finished
      test.should be_passed
    end

    it "transitions from a running state to a passed state" do
      test._start
      test.test_runner_finished
      test.should be_passed
    end

    it "stays in a passed state" do
      test._start
      test._pass
      test.test_runner_finished
      test.should be_passed
    end

    it "stays in a failed state" do
      test._start
      test._fail
      test.test_runner_finished
      test.should be_failed
    end

    it "stays in an aborted state" do
      test._start
      test._abort
      test.test_runner_finished
      test.should be_aborted
    end
  end

  context "when the test runner finishes with an error" do
    it "transitions from a waiting state to a failed state" do
      test.test_runner_finished_with_error
      test.should be_failed
    end

    it "transitions from a running state to a failed state" do
      test._start
      test.test_runner_finished_with_error
      test.should be_failed
    end

    it "transitions from a passed state to a failed state" do
      test._start
      test._pass
      test.test_runner_finished_with_error
      test.should be_failed
    end

    it "stays in a failed state" do
      test._start
      test._fail
      test.test_runner_finished
      test.should be_failed
    end

    it "stays in an aborted state" do
      test._start
      test._abort
      test.test_runner_finished
      test.should be_aborted
    end
  end

  context "when building" do
    it "prepends a logStart message to the javascript" do
      test.build {}
      test.compile.should == %Q{
        UIALogger.logStart('anything');
      }.strip_heredoc.strip
    end
    
    it "appends a single line script with a single automate call" do
      test.build do
        automate <<-JS
          UIALogger.logMessage('Hello World');
        JS
      end
      
      test.compile.should == %q{
        UIALogger.logStart('anything');
        UIALogger.logMessage('Hello World');
      }.strip_heredoc.strip
    end
    
    it "appends a multiple line script with a single automate call" do
      test.build do
        automate <<-JS
          UIALogger.logMessage('Hello World');
          UIALogger.logMessage('Hello Again');
        JS
      end
      
      test.compile.should == %q{
        UIALogger.logStart('anything');
        UIALogger.logMessage('Hello World');
        UIALogger.logMessage('Hello Again');
      }.strip_heredoc.strip
    end
    
    it "appends a multiple line script with multiple automate calls" do
      test.build do
        automate <<-JS
          UIALogger.logMessage('Hello World');
        JS
        automate <<-JS
          UIALogger.logMessage('Hello Again');
        JS
      end
      
      test.compile.should == %q{
        UIALogger.logStart('anything');
        UIALogger.logMessage('Hello World');
        UIALogger.logMessage('Hello Again');
      }.strip_heredoc.strip
    end
  end
end
