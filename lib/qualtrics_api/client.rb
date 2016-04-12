module QualtricsAPI
  class Client
    include QualtricsAPI::Connectable

    def initialize(api_token)
      @connection = establish_connection(api_token || fail('Please provide api token!'))
    end

    def surveys(options = {})
      @surveys ||= QualtricsAPI::SurveyCollection.new(options).propagate_connection(self)
    end

    def response_exports(options = {})
      @response_exports ||= QualtricsAPI::ResponseExportCollection.new(options).propagate_connection(self)
    end

    def panels(options = {})
      @panels ||= QualtricsAPI::PanelCollection.new(options).propagate_connection(self)
    end

    private

    def establish_connection(api_token)
      Faraday.new(url: QualtricsAPI::URL, headers: { 'X-API-TOKEN' => api_token }) do |faraday|
        faraday.request :json
        faraday.response :json, :content_type => /\bjson$/

        faraday.use FaradayMiddleware::FollowRedirects
        faraday.use QualtricsAPI::RequestErrorHandler

        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
