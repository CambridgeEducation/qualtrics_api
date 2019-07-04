module QualtricsAPI
  class DistributionCollection < BaseCollection
    values do
      attribute :id, String
    end

    def create(distribution)
      payload = distribution.to_create_json
      res = QualtricsAPI.connection(self)
              .post("distributions", payload)
              .body["result"]
      return QualtricsAPI::Distribution.new(distribution.attributes.merge({ id: res['id'] }))
    end

    private

    def build_result(element)
      QualtricsAPI::Distribution.new(element)
    end
  end
end
