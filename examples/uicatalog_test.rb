$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

UICATALOG = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec fixtures UICatalog.app]))

require 'minitest/autorun'
require 'ui_automation'

class UICatalogTest < UIAutomation::TestCase
  tests_application UICATALOG

  test "Interacting with text fields" do
    automate <<-JS
      var app = UIATarget.localTarget().frontMostApp();
      var window = app.mainWindow();
      var tableView = window.tableViews()[0];
      var textFieldsCell = tableView.cells()[2];
      if (textFieldsCell) {
        textFieldsCell.tap();
        UIATarget.localTarget().delay(1);
        UIALogger.logPass("It worked");
      } else {
        UIALogger.logFailure(textFieldsCell); 
      }
    JS
  end  
end
