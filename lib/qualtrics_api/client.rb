module QualtricsAPI
  class Client
    include QualtricsAPI::Connectable

    def initialize(api_token, data_center_id)
      @connection = establish_connection(api_token || fail('Please provide api token!'), data_center_id)
    end

    def surveys(options = {})
      QualtricsAPI::SurveyCollection.new(options).propagate_connection(self)
    end

    def response_exports(options = {})
      QualtricsAPI::ResponseExportCollection.new(options).propagate_connection(self)
    end

    def panels(options = {})
      QualtricsAPI::PanelCollection.new(options).propagate_connection(self)
    end

    def event_subscriptions(options = {})
      QualtricsAPI::EventSubscriptionCollection.new(options).propagate_connection(self)
    end

    def questions(options = {})
      QualtricsAPI::QuestionCollection.new(options).propagate_connection(self)
    end

    private

    def establish_connection(api_token, data_center_id)
      Faraday.new(url: QualtricsAPI.url(data_center_id), headers: { 'X-API-TOKEN' => api_token }) do |faraday|
        faraday.request :multipart
        faraday.request :json
        faraday.response :json, :content_type => /\bjson$/

        faraday.use FaradayMiddleware::FollowRedirects
        faraday.use QualtricsAPI::RequestErrorHandler

        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
