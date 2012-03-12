require 'minitest/unit'

class Hash
  def slice(*keys)
    Hash.new.tap do |hash|
      keys.each { |k| hash[k] = self[k] if has_key?(k) }
    end
  end
end

class TestRunner
  def initialize
    @runner = MiniTest::Unit.new
    @output = StringIO.new
    
    MiniTest::Unit.output = @output
  end

  def run_test_with_script_definition(script_definition)
    test_case = Class.new(MiniTest::Unit::TestCase) do
      def test_ui_automation
        automate script_definition
      end
    end

    @runner.run
  end

  def has_exited_with?(results)
    filtered = results.slice(:tests, :assertions, :failures, :errors, :skips)
    filtered.all? { |key, value| last_output =~ /#{value} #{key}/ }
  end
  
  def has_exited_without_any_errors_or_failures?
    has_exited_with?(errors: 0, failures: 0)
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
