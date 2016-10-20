require "bundler/gem_tasks"
require 'rake/testtask'
require 'rubycritic/rake_task'

Rake::TestTask.new do |task|
  task.libs.push 'lib'
  task.libs.push 'test'
  task.pattern = 'test/**/*_test.rb'
end

RubyCritic::RakeTask.new do |task|
  task.paths = FileList['lib/**/*.rb']
end

task default: [:test, :rubycritic]
