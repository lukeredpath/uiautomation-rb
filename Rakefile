require 'rspec/core/rake_task'

desc "Run all unit and integration specs"
RSpec::Core::RakeTask.new(:spec)

desc "Run the end to end acceptance specs"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = "spec/end-to-end/**/*.rb"
  t.rspec_opts = %w{--format documentation}
end

task :cleanup do
  sh "rm -fr Run*"
  sh "rm -fr *.trace"
end

task :default => :spec
