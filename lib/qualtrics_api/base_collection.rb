module QualtricsAPI
  class BaseCollection
    extend Forwardable
    include Enumerable
    include Virtus.value_object
    include QualtricsAPI::Extensions::SerializableCollection
    include QualtricsAPI::Connectable

    def_delegator :page, :each

    def fetch
      @page = []
      parse_fetch_response(QualtricsAPI.connection(self).get(list_endpoint))
      self
    end

    private

    def parse_fetch_response(response)
      @page = response.body["result"]["elements"].map do |element|
        build_result(element).propagate_connection(self)
      end
    end
  end
end
