require 'bundler/setup'
require 'mini_racer'
require 'json'
require 'timeout'
require 'sequel'

module Enrich
  # Connect to the SQLite3 database using the Sequel gem
  DB = Sequel.connect('sqlite://plugins.db')

  def self.run(event)
    event[:enrichment] = {}

    __return = lambda { |key, value| event[:enrichment][key.to_sym] = value }
    context = {
      request: lambda do |url, options|
        conn = Faraday.new(url: url)
        response = conn.get do |req|
          req.params = options.fetch('params', {}) if options.key?('params')
          req.headers = options.fetch('headers', {}) if options.key?('headers')
        end
        JSON.parse(response.body)
      end
    }

    mr = MiniRacer::Context.new

    mr.attach("__return", __return)
    mr.attach("context.request", context[:request])
    mr.eval('const event = ' + JSON.generate(event) + ";")

    # Retrieve the list of plugins and functions from the database
    plugins = Enrich.get_plugins

    # Loop through all plugins and functions and execute them
    plugins.each do |plugin|
      functions = []

      plugin[:code].scan(/function\s+([\w$]+)\s*\(([^)]*)\)\s*\{([\s\S]+?)\}(?=\s*function|\s*\z)/) do |name, _, body|
        body.gsub!(/return\s+((['"])[^'"]*\2|[^;\n]+)(?:\s*;)?/) { "__return('#{name}', #{$1});" }
        functions << { name: name, body: body.strip }
      end

      functions.each do |function|
        begin
          Timeout.timeout(5) do
            mr.eval(function[:body])
          end
        rescue Timeout::Error
          puts "Timeout"
        rescue MiniRacer::RuntimeError => e
          message = e.message.split("\n").first

          # Add 1 since the function definition is removed from the evaluated JS
          line = e.backtrace[0].match(/<anonymous>:(\d+):/)[1].to_i + 1

          puts "Error: #{message}"
          puts "Line: #{line}"
        end
      end

    end

    event
  end

  def self.get_plugins
    # Retrieve the list of plugins from the database
    plugins = DB[:plugins].all

    # Convert the plugins to an array of hashes with name and code keys
    plugins.map do |plugin|
      { name: plugin[:name], code: plugin[:code] }
    end
  end

end
