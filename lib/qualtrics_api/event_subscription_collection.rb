module QualtricsAPI
  class EventSubscriptionCollection < BaseCollection
    def [](survey_id)
      find(survey_id)
    end

    def create(publication_url, topics, opts = { encrypt: false })
      payload = {
        publicationUrl: publication_url,
        topics: topics
      }.merge(opts)
      res = QualtricsAPI.connection(self)
              .post(list_endpoint, payload)
              .body["result"]
      find(res["id"])
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