require 'json'
require_relative 'enrich'

# Get the argument passed to the script
action = ARGV[0]

if action == 'enrich'
  # Define the event to enrich
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
