$:.unshift('/Library/RubyMotion/lib')
platform = ENV.fetch('platform', 'ios') # allow setting from the command line, default to iOS
case platform
when 'ios' then require 'motion/project/template/ios'
when 'osx' then require 'motion/project/template/osx'
when 'android' then require 'motion/project/template/android'
else raise "Unsupported platform #{platform}"
end

require 'bundler'
Bundler.require
require 'bundler/gem_tasks'

# Testing Dependencies
require 'motion-spec'
require 'motion-stump'
require 'webstub'

Motion::Project::App.setup do |app|
  app.name = 'motion-rest-test-app'
end
