module QualtricsAPI
  class SurveyCollection < BaseCollection
    def [](survey_id)
      find(survey_id)
    end

    private

    def build_result(element)
      QualtricsAPI::Survey.new(element)
    end

    def list_endpoint
      'surveys'
    end

    def endpoint(id)
      "surveys/#{id}"
    end
  end
end
