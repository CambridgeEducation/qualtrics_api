module QualtricsAPI
  class BaseCollection
    extend Forwardable
    include Enumerable
    include Virtus.value_object
    include QualtricsAPI::Extensions::SerializableCollection
    include QualtricsAPI::Connectable

    values do
      attribute :page, Array, :default => []
      attribute :first_page, Boolean, :default => true
      attribute :next_endpoint, String
    end

    def_delegator :page, :each

    def fetch
      endpoint = first_page ? list_endpoint : next_endpoint
      parse_fetch_response(QualtricsAPI.connection(self).get(endpoint)) if endpoint
      self
    end

    def last_page?
      !first_page && !next_endpoint
    end

    private

    def parse_fetch_response(response)
      @page = response.body["result"]["elements"].map do |element|
        build_result(element).propagate_connection(self)
      end
      @next_endpoint = response.body["result"]["nextPage"]
      @first_page = false
    end
  end
end
