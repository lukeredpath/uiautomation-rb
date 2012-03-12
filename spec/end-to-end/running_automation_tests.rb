require 'spec_helper'
require 'support/test_runner'

describe "UIAutomation, when running tests:", :type => :ete do
  let(:test_runner) { TestRunner.new }

  EMPTY_SCRIPT = ""

  it "Runs an empty automation script, passes and exits" do
    test_runner.run_test_with_script_definition(EMPTY_SCRIPT)
    test_runner.should have_exited_without_any_errors_or_failures,
      error_message_without_test_output("Expected no errors or failures")
  end
end
