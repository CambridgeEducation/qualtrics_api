module QualtricsAPI
  class SurveyCollection < BaseCollection
    values do
      attribute :all, Array, :default => []
    end

    def fetch
      @all = []
      parse_fetch_response(QualtricsAPI.connection(self).get('surveys'))
      self
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

    def parse_fetch_response(response)
      @all = response.body["result"]['elements'].map do |elements|
        QualtricsAPI::Survey.new(elements).propagate_connection(self)
      end
    end
  end
end
