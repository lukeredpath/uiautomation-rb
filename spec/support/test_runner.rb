require 'minitest/unit'

class Hash
  def slice(*keys)
    Hash.new.tap do |hash|
      keys.each { |k| hash[k] = self[k] if has_key?(k) }
    end
  end
end

class TestRunner
  RESULTS_KEYS = [:tests, :assertions, :failures, :errors, :skips]
  
  def initialize(options)
    @runner = MiniTest::Unit.new
    @output = StringIO.new
    @app_path = options[:app_path]
    @failure_messages = []
    
    MiniTest::Unit.output = @output
    MiniTest::Unit::TestCase.reset
  end
  
  def reset
    MiniTest::Unit::TestCase.reset
    @output.truncate(0)
  end

  def run_test_with_script_definition(script_definition)
    test_case = Class.new(UIAutomation::TestCase)
    test_case.application_under_test = @app_path
    test_case.test do
      automate(script_definition)
    end

    @runner.run
  end

  def has_exited_with?(results)
    filtered = results.slice(*RESULTS_KEYS)
    filtered.all? { |key, value| last_output =~ /#{value} #{key}/ }
  end
  
  def failures
    last_output.match(/\d+\) Failure:\n.* \[.*\]:\n(.*)$/).to_a[1..-1]
  end
  
  def has_reported_failure?(failure_message)
    failures.include?(failure_message)
  end
  
  def has_error_in_output?
    last_output.match(/Error/)
  end
  
  def last_output
    @output.rewind
    @output.read
  end
  
  def test_count
    count_for(:tests)
  end
  
  def count_for(result_key)
    if result_key == :tests
      # \d+ tests can appear twice in the output, so be more specific
      last_output.match(/(\d+) #{result_key}, \d+ assertions/)[1].to_i
    else
      last_output.match(/(\d+) #{result_key}/)[1].to_i
    end
  end
  
  def delineated_last_output
    ["\n\n### BEGIN MINITEST OUTPUT ###",
     last_output,
     "### END MINITEST OUTPUT ###\n\n"].join("\n")
  end
end
