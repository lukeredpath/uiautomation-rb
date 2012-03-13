module EndToEndHelpers
  def error_message_without_test_output(message)
    "#{message}, test output was: #{test_runner.delineated_last_output}"
  end
end

RSpec::Matchers.define :have_exited_without_any_errors_or_failures do |expected|
  match do |actual|
    actual.has_exited_with?(errors: 0, failures: 0) && !actual.has_error_in_output?
  end
  
  failure_message_for_should do
    error_message_without_test_output("Expected no errors or failures")
  end
end

RSpec::Matchers.define :have_reported_test_count_of do |count|
  match do |actual|
    actual.has_exited_with?(tests: count)
  end
  
  failure_message_for_should do
    "Expected #{count} tests but #{actual.test_count} were reported"
  end
end

RSpec::Matchers.define :have_exited_with do |count|
  match do |actual|
    actual.has_exited_with?(@key => count)
  end
  
  failure_message_for_should do
    "Expected #{count} #{@key} but #{actual.count_for(@key)} were reported"
  end
  
  TestRunner::RESULTS_KEYS.each do |key|
    chain(key) { @key = key }
  end
end
