module EndToEndHelpers
  def error_message_without_test_output(message)
    "#{message}, test output was: #{test_runner.delineated_last_output}"
  end
end

RSpec::Matchers.define :have_exited_without_any_errors_or_failures do |expected|
  match do |actual|
    actual.has_exited_with?(errors: 0, failures: 0)
  end
  
  failure_message_for_should do
    error_message_without_test_output("Expected no errors or failures")
  end
end
