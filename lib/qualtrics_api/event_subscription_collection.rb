module QualtricsAPI
  class EventSubscriptionCollection < BaseCollection
    alias_method :[], :find

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

    def delete(id)
      QualtricsAPI.connection(self)
        .delete(endpoint(id))
    end

    def delete_all
      QualtricsAPI.connection(self)
        .delete(list_endpoint)
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