$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

UICATALOG = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec fixtures UICatalog.app]))

require 'minitest/autorun'
require 'ui_automation'

class UICatalogTest < UIAutomation::TestCase
  tests_application UICATALOG

  test "Interacting with text fields" do
    automate <<-JS
      UIATarget.localTarget().delay(5);
      var app = UIATarget.localTarget.frontMostApp();
      var window = app.mainWindow();
      var tableView = mainWindow.tableViews()[0];
      var textFieldsCell = tableView.cells()[2];
      if (textFieldsCell)) {
        textFieldsCell.tap();
        UIALogger.logPass("It worked");
      } else {
       UIALogger.logFailure(textFieldsCell); 
      }
    JS
  end  
end
