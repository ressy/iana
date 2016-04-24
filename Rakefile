#!/usr/bin/env ruby
# vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2

# Rakefile
# coding:utf-8

require 'rubygems'
require 'rake'
require 'yard'

require 'rake/clean'
require 'rake/testtask'

CLEAN.include('cache/*', 'Manifest', 'iana.gemspec')
CLOBBER.include('cache')

task :default do
  system("rake -T")
end

# override RDoc with YARD
desc 'generate documentation'
task :doc do
  system("yard --doc")
end

# run test suite
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*.rb']
  t.verbose = true
end

desc 'count source lines of code'
task :count do
  system('cloc lib')
end

namespace :todo do
  desc 'List TODOs in all .rb files under lib/'
  task(:list) do
      FileList["lib/**/*.rb", "bin/**/*.rb"].egrep(/TODO/)
  end
 
  desc 'Edit all TODOs in VIM' # or your favorite editor
  task(:edit) do
      # jump to the first TODO in the first file
      cmd = 'vim +/TODO/' 
 
      filelist = []
      FileList["lib/**/*.rb"].egrep(/TODO/) { |fn,cnt,line| filelist << fn }
 
      # will fork a new process and exit, if you're using gvim
      system("#{cmd} #{filelist.sort.join(' ')}") 
  end
end
