module EndToEndHelpers
  def error_message_without_test_output(message)
    "#{message}, test output was: #{test_runner.delineated_last_output}"
  end
end
