require 'spec_helper'
require 'support/test_runner'

describe "UIAutomation, when running tests:", :type => :ete do
  let(:test_runner) { TestRunner.new(app_path: UICATALOG_APP_PATH) }
  
  before { test_runner.reset }

  it "Runs a single test with an empty automation script, passes and exits" do
    test_runner.run_test_with_script_definition("")
    
    test_runner.should have_reported_test_count_of(1)
    test_runner.should have_exited_without_any_errors_or_failures
  end
  
  it "Runs a single test with a minimal automation script that just logs, passes and exits" do
    test_runner.run_test_with_script_definition <<-JS
      UIALogger.logMessage('Hello from UIAutomation')
    JS

    test_runner.should have_reported_test_count_of(1)
    test_runner.should have_exited_without_any_errors_or_failures
  end
  
  it "Runs a single failing test, fails and exits" do
    test_runner.run_test_with_script_definition <<-JS
      UIALogger.logFail('Something went wrong')
    JS
    
    test_runner.should have_reported_test_count_of(1)
    test_runner.should have_exited_with(1).failures
    test_runner.should have_reported_failure("Something went wrong")
  end
  
  it "Cleans up after itself by removing any instruments artefacts" do
    test_runner.run_test_with_script_definition("")
    test_runner.should have_cleaned_up_all_instruments_artefacts
  end
end
