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
  end
end
