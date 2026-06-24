module SolrCloud
  class Connection
    # Create a Faraday connection object to base the API client off of
    # @see #initialize
    # This allows setting timeouts in environment variables
    def create_raw_connection(url:, adapter: :httpx, user: nil, password: nil, logger: nil)
      Faraday.new(request: {
        params_encoder: Faraday::FlatParamsEncoder,
        timeout: timeout(ENV["SOLR_TIMEOUT"]),
        open_timeout: timeout(ENV["SOLR_OPEN_TIMEOUT"]),
        read_timeout: timeout(ENV["SOLR_READ_TIMEOUT"]),
        write_timeout: timeout(ENV["SOLR_WRITE_TIMEOUT"])
      }, url: URI(url)) do |faraday|
        faraday.use Faraday::Response::RaiseError
        faraday.request :url_encoded
        if user
          faraday.request :authorization, :basic, user, password
        end
        faraday.request :json
        faraday.response :json
        if logger
          faraday.response :logger, logger
        end
        faraday.adapter adapter
        faraday.headers["Content-Type"] = "application/json"
      end
    end

    private

    def timeout(value)
      if value.is_a?(String)
        value.to_i
      end
    end
  end
end
