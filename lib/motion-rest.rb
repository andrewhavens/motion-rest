unless defined?(Motion::Project::Config)
  raise 'This gem is intended to be used in a RubyMotion project.'
end

require 'afmotion'
require 'motion-support/inflector'
require 'sugarcube-nsdate'

Motion::Project::App.setup do |app|
  app.files += Dir.glob(File.join(File.dirname(__FILE__), 'motion-rest', '**', '*.rb'))
end
