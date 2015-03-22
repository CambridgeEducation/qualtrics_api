module QualtricsAPI

  class Client
    attr_reader :api_token

    def initialize(options = {})
      @api_token = options[:api_token]
    end

    def connection
      @conn ||= Faraday.new(url: QualtricsAPI::URL,
                            params: { apiToken: @api_token }) do |faraday|
        faraday.request :json
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end
  end

end
