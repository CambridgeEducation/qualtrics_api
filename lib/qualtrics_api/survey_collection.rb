module QualtricsAPI
  class SurveyCollection < BaseCollection
    values do
      attribute :scope_id, String
      attribute :all, Array, :default => []
    end

    attr_writer :scope_id

    def fetch(options = {})
      @all = []
      update_query_attributes(options)
      parse_fetch_response(QualtricsAPI.connection(self).get('surveys', query_params))
      self
    end

    def query_attributes
      {
        :scope_id => @scope_id
      }
    end

    def update_query_attributes(new_attributes = {})
      @scope_id = new_attributes[:scope_id] if new_attributes.key?(:scope_id)
    end

    def [](survey_id)
      find(survey_id)
    end

    def find(survey_id)
      @all.detect do |survey|
        survey.id == survey_id
      end || QualtricsAPI::Survey.new("id" => survey_id)
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
      @all = response.body["result"]['elements'].map do |elements|
        QualtricsAPI::Survey.new(elements).propagate_connection(self)
      end
    end
  end
end
