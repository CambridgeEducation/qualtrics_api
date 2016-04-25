module QualtricsAPI
  class BaseCollection
    extend Forwardable
    include Enumerable
    include Virtus.value_object
    include QualtricsAPI::Extensions::SerializableCollection
    include QualtricsAPI::Connectable

    values do
      attribute :page, Array, :default => []
      attribute :fetched, Boolean, :default => false
      attribute :next_endpoint, String
    end

    def_delegator :page, :each

    def fetch
      parse_fetch_response(QualtricsAPI.connection(self).get(list_endpoint))
      self
    end

    def next_page
      raise NotFoundError unless next_page?
      self.class.new.tap do |r|
        r.parse_fetch_response(QualtricsAPI.connection(self).get(next_endpoint))
      end
    end

    def find(id)
      response = QualtricsAPI.connection(self).get(endpoint(id))
      return nil unless response.status == 200
      build_result(response.body['result']).propagate_connection(self)
    end

    def next_page?
      raise NotYetFetchedError unless fetched
      !next_endpoint.nil?
    end

    protected

    def parse_fetch_response(response)
      @page = response.body["result"]["elements"].map do |element|
        build_result(element).propagate_connection(self)
      end
      @next_endpoint = response.body["result"]["nextPage"]
      @fetched = true
    end
  end
end
