require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'hoe'
begin
  require 'spec/rake/spectask'
rescue LoadError
  puts 'To use rspec for testing you must install rspec gem:'
  puts '$ sudo gem install rspec'
  exit
end

class Hoe
  def extra_deps 
    @extra_deps.reject { |x| Array(x).first == 'hoe' } 
  end 
end

desc 'Generate website files'
task :website_generate do
  require 'scripts/lib-txt2html'
  t2h = Txt2Html.new
  Dir['website/**/*.txt'].each do |txt|
    puts txt
    t2h.translate(txt, txt.gsub(/txt$/, 'html'))
  end
end

# add chmod.
task :website_generate do
  sh %{ chmod -R go+rx website }
end

desc 'Upload website files to rubyforge'
task :website_upload do
  host = "#{rubyforge_username}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{PATH}/"
  local_dir = 'website'
  sh %{rsync -aCv #{local_dir}/ #{host}:#{remote_dir}}
end

desc 'Generate and upload website files'
task :website => [:website_generate, :website_upload, :publish_docs]

desc 'Release the website and new gem version'
task :deploy => [:check_version, :website, :release] do
  puts "Remember to create SVN tag:"
  puts "svn copy svn+ssh://#{rubyforge_username}@rubyforge.org/var/svn/#{PATH}/trunk " +
    "svn+ssh://#{rubyforge_username}@rubyforge.org/var/svn/#{PATH}/tags/REL-#{VERS} "
  puts "Suggested comment:"
  puts "Tagging release #{CHANGES}"
end

desc 'Runs tasks website_generate and install_gem as a local deployment of the gem'
task :local_deploy => [:website_generate, :install_gem]

task :check_version do
  unless ENV['VERSION']
    puts 'Must pass a VERSION=x.y.z release version'
    exit
  end
  unless ENV['VERSION'] == VERS
    puts "Please update your version.rb to match the release version, currently #{VERS}"
    exit
  end
end

desc "Run the specs under spec/models"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/*_spec.rb']
  t.libs << "lib"
end

# add chmod.
task :docs do
  sh %{ chmod -R go+rx doc }
end

# clear current task
module Rake
  class Task
    def clear_actions
      @actions.clear
    end
  end
end

# clear current task
t = Rake.application.lookup(:install_gem)
t.clear_actions if t

# redefine task
task :install_gem => [:clean, :package] do
  if /mswin32/ =~ RUBY_PLATFORM || /cygwin/ =~ RUBY_PLATFORM
    sh "gem.cmd install pkg/*.gem"	# for Cygwin
  else
    sh "sudo gem install pkg/*.gem"
  end
end

task :clean => [:chmod]

desc 'Change mode to erase executable bits.'
task :chmod do
  sh "chmod 644 Rakefile ChangeLog"
  sh "chmod 644 *.txt */*.txt"
  sh "chmod 644 */*.html"
  sh "chmod 644 */*.rhtml"
  sh "chmod 644 */*/*.js"
  sh "chmod 644 */*/*.css"
  sh "chmod 644 *.rb */*.rb */*/*.rb"
  sh "chmod 644 */*.opts"
  sh "chmod 755 scripts/*"
end

desc 'Create Manifest.txt file.'
task :manifest => [:chmod, :clean] do
  ruby "scripts/makemanifest.rb"
end

# Add tasks to gem
task :gem => [:manifest]

desc "Default task is to run specs"
task :default => [:spec]
