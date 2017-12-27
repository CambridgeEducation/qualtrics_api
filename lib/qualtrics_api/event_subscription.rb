module QualtricsAPI
  class EventSubscription < BaseModel
    values do
      attribute :id, String
      attribute :scope, String
      attribute :topics, String
      attribute :publication_url, String
      attribute :encrypted, Boolean, default: false
      attribute :successful_calls, Integer, default: 0
    end

    def delete
      QualtricsAPI.connection(self)
        .delete(endpoint)
      return true
    end

    private

    def endpoint
      "eventsubscriptions/#{id}"
    end

    def attributes_mappings
      {
        id: "id",
        scope: "scope",
        topics: "topics",
        publication_url: "publicationUrl",
        encrypted: "encrypted",
        successful_calls: "successfulCalls"
      }
    end
  end
end