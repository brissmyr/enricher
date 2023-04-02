require 'bundler/setup'

require 'sinatra'
require_relative 'enrich'

post '/enrich' do
  content_type :json

  payload = JSON.parse(request.body.read)

  event = {
    properties: payload['properties'] || {},
    enrichment: {}
  }

  result = Enrich.run(event)

  JSON.generate(result)
end
