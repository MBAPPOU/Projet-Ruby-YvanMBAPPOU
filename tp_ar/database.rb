require 'active_record'
require_relative 'lib/person'

config_file = File.join(File.dirname(__FILE__),"config","database.yml")

puts YAML.load(File.open(config_file)).inspect

base_directory = File.dirname(__FILE__)
configuration = YAML.load(File.open(config_file))["development"]
configuration["database"] = File.join(base_directory,configuration["database"])

ActiveRecord::Base.establish_connection(configuration)


