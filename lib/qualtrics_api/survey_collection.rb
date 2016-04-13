module QualtricsAPI
  class SurveyCollection < BaseCollection
    values do
      attribute :page, Array, :default => []
    end

    def [](survey_id)
      find(survey_id)
    end

    def find(survey_id)
      @page.detect do |survey|
        survey.id == survey_id
      end || QualtricsAPI::Survey.new("id" => survey_id)
    end

    private

    def parse_fetch_response(response)
      @page = response.body["result"]['elements'].map do |elements|
        QualtricsAPI::Survey.new(elements).propagate_connection(self)
      end
    end

    def list_endpoint
      'surveys'
    end
  end
end
