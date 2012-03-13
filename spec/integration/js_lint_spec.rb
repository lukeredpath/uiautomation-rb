require 'spec_helper'
require 'tempfile'

describe UIAutomation::JSLint do
  before :all do
    unless UIAutomation::JSLint.available?
      raise "Cannot run JSLint integration tests as jsl not in path"
    end
  end
  
  it "returns true for valid Javascript" do
    script = Tempfile.new("javascript").tap do |io|
      io.write "UIALogger.logMessage('hello');"
      io.close
    end
    
    UIAutomation::JSLint.check_file(script.path).should be_true
  end
  
  it "returns false for invalid Javascript" do
    script = Tempfile.new("javascript").tap do |io|
      io.write "foo())"
      io.close
    end
    
    UIAutomation::JSLint.check_file(script.path).should be_false
  end
end
