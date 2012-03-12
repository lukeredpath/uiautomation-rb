require 'minitest/unit'

class Hash
  def slice(*keys)
    Hash.new.tap do |hash|
      keys.each { |k| hash[k] = self[k] if has_key?(k) }
    end
  end
end

class TestRunner
  def initialize(options)
    @runner = MiniTest::Unit.new
    @output = StringIO.new
    @app_path = options[:app_path]
    
    MiniTest::Unit.output = @output
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
    filtered = results.slice(:tests, :assertions, :failures, :errors, :skips)
    filtered.all? { |key, value| last_output =~ /#{value} #{key}/ }
  end
  
  def last_output
    @output.rewind
    @output.read
  end
  
  def delineated_last_output
    ["\n\n### BEGIN MINITEST OUTPUT ###",
     last_output,
     "### END MINITEST OUTPUT ###\n\n"].join("\n")
  end
end
