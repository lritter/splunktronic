require 'optparse'
require 'splunking/cli'
require 'splunking/client'
require 'splunktronic'
require 'pp'

module Splunktronic
  class CLI
    attr_reader :argv
    attr_reader :options

    def initialize(argv)
      @argv = argv
    end

    def run
      parse_args
      validate_options
      splunktronic = ::Splunktronic::Bridge.new(options)
      splunktronic.perform 
    end

    def parse_args
      @options = {}
      option_parser.parse!(argv)
      options[:port] ||= ::Splunking::Client::DEFAULT_SPLUNK_SERVICE_PORT
      options[:logger] ||= Logger.new($stderr)
      options[:log_level] ||= Logger::ERROR
      options[:logger].level = options[:log_level]
    end

    def validate_options
      missing_args = required_options.inject([]) do |missing, item| 
        missing << item if !options.key?(item)
        missing
      end

      if !missing_args.empty?
        raise OptionParser::MissingArgument, missing_args.join(', ')
      end
    end

    def required_options
      [:username, :password, :host, :search, :key, :stream, :value_name]
    end

    def option_parser
      @option_parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: example.rb [options]"

        opts.on("--log-level [LEVEL]") do |level|
          options[:log_level] = Logger.const_get(level.upcase)
        end

        ## Leftronic options ##

        opts.on("-k", "--leftronic-key ACCESSKEY") do |key|
          options[:key] = key
        end

        opts.on("-S", "--leftronic-stream STREAM") do |stream|
          options[:stream] = stream
        end

        opts.on("-n", "--value-name NAME") do |name|
          options[:value_name] = name
        end


        ## Options passed to Splunking ##

        opts.on("-u", "--splunk-username USER") do |u|
          options[:username] = u
        end

        opts.on("-p", "--splunk-password PASS") do |p|
          options[:password] = p
        end

        opts.on("--splunk-host HOST") do |h|
          options[:host] = h
        end

        opts.on("--splunk-port [PORT]", OptionParser::DecimalInteger) do |port|
          options[:port] = port
        end

        opts.on("-s", "--search SEARCH", "Search as you would type it into splunk") do |s|
          options[:search] = s
        end
      end
    end
  end
end