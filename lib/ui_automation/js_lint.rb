module UIAutomation
  class JSLint
    def self.available?
      `which jsl`.strip != ""
    end
    
    def self.check_file(path)
      result = `#{`which jsl`.strip} -process #{path} 2>&1`.strip
      result.match(/0 error\(s\), 0 warning\(s\)/)
    end
  end
end
