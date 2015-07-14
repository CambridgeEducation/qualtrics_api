module QualtricsAPI
  module Client
    include Virtus.value_object

    def surveys(options = {})
      @surveys = nil if @surveys && @surveys.scope_id != options[:scope_id]
      @surveys ||= QualtricsAPI::SurveyCollection.new(options)
    end

    def response_exports(options = {})
      @response_exports ||= QualtricsAPI::ResponseExportCollection.new(options)
    end

    def panels(options = {})
      @panels ||= QualtricsAPI::PanelCollection.new(options)
    end

    def connection
      api_token ||= QualtricsAPI.api_token || fail('Please configure api token!')
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
