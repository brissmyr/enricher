require 'bundler/setup'

require 'faraday'
require 'json'

api_url = 'http://localhost:4567/events'

event = {
  'type' => 'user_action',
  'properties' => {
    'custom_ip' => '8.8.8.8'
  }
}

conn = Faraday.new(url: api_url)
response = conn.post do |req|
  req.headers['Content-Type'] = 'application/json'
  req.body = event.to_json
end

puts "API Response: #{response.status}"
puts JSON.parse(response.body)
