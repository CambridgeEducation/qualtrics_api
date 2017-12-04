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

    def map
      res = []
      each_page do |page|
        page.each do |element|
          res.push(yield element)
        end
      end
      res
    end

    def all
      map {|element| element}
    end

    def each_page
      endpoint = list_endpoint
      loop do
        response = QualtricsAPI.connection(self).get(endpoint)
        endpoint = response.body["result"]["nextPage"]
        yield parse_page(response)
        break unless endpoint
      end
    end

    def find(id)
      response = QualtricsAPI.connection(self).get(endpoint(id))
      return nil unless response.status == 200
      build_result(response.body['result']).propagate_connection(self)
    end

    protected

    def page_endpoint(fetched)
      fetched ? @next_endpoint : list_endpoint
    end

    def parse_page(response)
      response.body["result"]["elements"].map do |element|
        build_result(element).propagate_connection(self)
      end
    end
  end
end
