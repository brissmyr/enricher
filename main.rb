require 'json'
require_relative 'enrich'

action = ARGV[0]

if action == 'enrich'
  event = {
    'type' => 'user_action',
    'properties' => {
      'custom_ip' => '8.8.8.8'
    }
  }

  result = Enrich.run(event)
  puts JSON.pretty_generate(result)
elsif action == 'list'
  plugins = Enrich.get_plugins
  puts JSON.pretty_generate(plugins)
else
  puts "Invalid argument: #{action}"
end
