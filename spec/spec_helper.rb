require 'support/end_to_end_helpers'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include EndToEndHelpers, :type => :ete
end
