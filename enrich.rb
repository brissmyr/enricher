require 'bundler/setup'
require 'mini_racer'
require 'json'
require 'timeout'

module Enrich
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

    plugin_files = Dir['plugins/*.js']

    # Create a thread for each plugin file
    threads = plugin_files.map do |file|
      Thread.new do
        # Find all the top-level functions in the file
        functions = []
        file_content = File.read(file)
        file_content.scan(/function\s+([\w$]+)\s*\(([^)]*)\)\s*\{([\s\S]+?)\}(?=\s*function|\s*\z)/) do |name, _, body|
          body.gsub!(/return\s+((['"])[^'"]*\2|[^;\n]+)(?:\s*;)?/) { "__return('#{name}', #{$1});" }
          functions << { name: name, body: body.strip }
        end

        # Loop through all functions in the current file and execute them
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
    end

    # Wait for all threads to finish executing before returning the enriched event
    threads.each(&:join)

    event
  end
end
