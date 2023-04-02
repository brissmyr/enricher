require 'bundler/setup'
require 'sinatra'
require_relative 'plugin'

before do
  content_type :json
end

get '/' do
  content_type :html
  File.read(File.join('public', 'index.html'))
end

post '/enrich' do
  event = JSON.parse(request.body.read)

  plugins = Plugin.all

  enriched_event = plugins.reduce(event) { |e, plugin| plugin.run(e) }

  JSON.generate(enriched_event)
end

post '/plugins' do
  payload = JSON.parse(request.body.read)

  plugin = Plugin.create(payload['name'], payload['code'])

  plugin.to_json
end

get '/plugins' do
  Plugin.all.to_json
end

put '/plugins/:id' do |id|
  payload = JSON.parse(request.body.read)

  plugin = Plugin.find(id.to_i)
  if plugin.nil?
    status 404
    return
  end

  plugin.name = payload['name'] if payload.key?('name')
  plugin.code = payload['code'] if payload.key?('code')

  plugin.save

  plugin.to_json
end


delete '/plugins/:id' do |id|
  plugin = Plugin.find(id.to_i)
  if plugin.nil?
    status 404
    return
  end

  plugin.destroy

  plugin.to_json
end
