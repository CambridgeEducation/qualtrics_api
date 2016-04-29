module QualtricsAPI
  class BaseCollection
    extend Forwardable
    include Enumerable
    include Virtus.value_object
    include QualtricsAPI::Extensions::SerializableCollection
    include QualtricsAPI::Connectable

    def each
      each_page do |page|
        page.each do |element|
          yield element
        end
      end
    end

    def each_page
      @fetched = false
      loop do
        yield parse_fetch_response(QualtricsAPI.connection(self).get(page_endpoint))
        break unless page_endpoint
      end
    end

    def find(id)
      response = QualtricsAPI.connection(self).get(endpoint(id))
      return nil unless response.status == 200
      build_result(response.body['result']).propagate_connection(self)
    end

    protected

    def page_endpoint
      @fetched ? @next_endpoint : list_endpoint
    end

    def parse_fetch_response(response)
      @next_endpoint = response.body["result"]["nextPage"]
      @fetched = true
      parse_page(response)
    end
  
    def parse_page(response)
      response.body["result"]["elements"].map do |element|
        build_result(element).propagate_connection(self)
      end
    end
  end
end
