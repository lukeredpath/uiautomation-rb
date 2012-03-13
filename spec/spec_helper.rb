require 'support/end_to_end_helpers'
require 'support/utilities'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include EndToEndHelpers, :type => :ete
end

UICATALOG_APP_PATH = File.expand_path("fixtures/UICatalog.app", File.dirname(__FILE__))
PROJECT_ROOT = File.join(File.dirname(__FILE__), "..")

$:.unshift File.join(PROJECT_ROOT, "lib")

require 'ui_automation'
