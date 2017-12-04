module QualtricsAPI
  class EventSubscriptionCollection < BaseCollection
    def [](survey_id)
      find(survey_id)
    end

    private

    def build_result(element)
      QualtricsAPI::EventSubscription.new(element)
    end

    def list_endpoint
      "eventsubscriptions"
    end

    def endpoint(id)
      "eventsubscriptions/#{id}"
    end
  end
end