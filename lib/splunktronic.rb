require 'leftronic'

module Splunktronic
  class Bridge
    attr_reader :options

    def initialize(options={})
      @options = options
    end

    def perform
      post_number_to_leftronic(extract_results_for_leftronic(search))
    end

    private
    def leftronic
      @leftronic_client ||= ::Leftronic.new(options[:key])
    end

    def splunk
      @splunk_client ||= ::Splunking::Client.build(options)
    end

    def extract_results_for_leftronic(results)
      result = results.last
      Float(result[options[:value_name]])
    end

    def search
      job = splunk.search(options[:search])
      job.wait
      job.results
    end

    def post_number_to_leftronic(number)
      splunk.session.logger.info "Posting #{number.inspect} to #{options[:stream].inspect}"
      leftronic.push options[:stream], number
    end
  end
end