module QualtricsAPI

  class SurveyCollection
    attr_accessor :scope_id

    def initialize(options = {})
      @conn = options[:connection]
      @scope_id = options[:scope_id]
    end

    def fetch(options = {})
      @conn.get('surveys', query_params(options))
    end

    def attributes
      {
        :scope_id => @scope_id
      }
    end

    private

    def attributes_mapping
      {
        :scope_id => "scopeId"
      }
    end

    def path
      '/surveys'
    end

    def query_params(options)
      params = attributes.merge(options)
      params.map do |k, v|
        [attributes_mapping[k], v]
      end.to_h
    end
  end

end
