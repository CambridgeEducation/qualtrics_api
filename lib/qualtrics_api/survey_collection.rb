module QualtricsAPI

  class SurveyCollection
    extend Forwardable
    include Enumerable

    attr_accessor :scope_id
    attr_reader :all

    def_delegator :all, :each
    def_delegator :all, :size

    def initialize(options = {})
      @conn = options[:connection]
      @scope_id = options[:scope_id]
      @all = []
    end

    def fetch(options = {})
      @all = []
      update_query_attributes(options)
      parse_fetch_response(@conn.get('surveys', query_params))
      self
    end

    def query_attributes
      {
        :scope_id => @scope_id
      }
    end

    def update_query_attributes(new_attributes = {})
      @scope_id = new_attributes[:scope_id] if new_attributes.has_key? :scope_id
    end

    private

    def attributes_mapping
      {
        :scope_id => "scopeId"
      }
    end

    def query_params
      query_attributes.map do |k, v|
        [attributes_mapping[k], v] unless v.nil? || v.to_s.empty?
      end.compact.to_h
    end

    def parse_fetch_response(response)
      @all = response.body["result"].map do |result|
        QualtricsAPI::Survey.new result
      end
    end
  end

end
