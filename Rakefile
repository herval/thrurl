require 'rake/testtask'

require 'bundler/setup'
require "bundler/version"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

Bundler::GemHelper.install_tasks

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*test.rb']
  t.verbose = true
end

task :build do
  system "gem build thrurl.gemspec"
end
 
task :release => :build do
  system "gem push thrurl-#{Bundler::VERSION}"
end