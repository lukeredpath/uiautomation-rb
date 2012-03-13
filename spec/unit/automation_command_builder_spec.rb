require 'spec_helper'

describe UIAutomation::AutomationCommandBuilder do
  let(:template)   { "/path/to/Automation.template" }
  let(:builder)    { UIAutomation::AutomationCommandBuilder.new(template) }
  
  before do
    builder.app_path = "/my/app"
    builder.script_path = "/my/script"
  end
  
  it "returns an instance of Command" do
    builder.build.should be_kind_of(UIAutomation::Command)
  end
  
  it "constructs the right arguments to the instruments tool" do
    command = builder.build
    command.to_s.should == "instruments -t /path/to/Automation.template /my/app -e UIASCRIPT /my/script"
  end
  
  it "raises if app_path is nil" do
    builder.app_path = nil
    expect{ builder.build }.to raise_error
  end
  
  it "raises if script_path is nil" do
    builder.script_path = nil
    expect{ builder.build }.to raise_error
  end
end
