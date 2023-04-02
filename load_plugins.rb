require 'sequel'
require_relative 'enrich'

DB = Sequel.connect('sqlite://plugins.db')

DB.create_table?(:plugins) do
  primary_key :id
  String :name
  Text :code
end

# Loop through all JavaScript files in the plugins directory
Dir.glob('plugins/*.js').each do |file|
  name = File.basename(file, '.js')
  code = File.read(file)
  Enrich.create_plugin(name, code)
end
