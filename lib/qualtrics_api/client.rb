module QualtricsAPI
  class Client
    include Virtus.value_object

    def surveys(options = {})
      @surveys ||= QualtricsAPI::SurveyCollection.new(options.merge(connection: connection))
    end

    def response_exports(options = {})
      @response_exports ||= QualtricsAPI::ResponseExportCollection.new(options.merge(connection: connection))
    end

    def panels(options = {})
      @panels ||= QualtricsAPI::PanelCollection.new(options.merge(connection: connection))
    end

    def connection
      api_token ||= QualtricsAPI.api_token || fail('Please set api token!')
      @conn ||= Faraday.new(url: QualtricsAPI::URL, params: { apiToken: api_token }) do |faraday|
        faraday.request :url_encoded
        faraday.response :json, :content_type => /\bjson$/

        faraday.use FaradayMiddleware::FollowRedirects
        faraday.use QualtricsAPI::RequestErrorHandler

        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
