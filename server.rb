require 'bundler/setup'
require 'sinatra'
require_relative 'enrich'

# Serve the index.html file
get '/' do
  File.read(File.join('public', 'index.html'))
end

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

get '/list' do
  content_type :json

  plugins = Enrich.get_plugins
  JSON.pretty_generate(plugins)
end
