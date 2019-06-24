module QualtricsAPI
  class DistributionLinkCollection < BaseCollection
    def each(survey_id, distribution_id)
      each_page(survey_id, distribution_id) do |page|
        page.each do |element|
          yield element
        end
      end
    end

    def each_page(survey_id, distribution_id)
      endpoint = list_endpoint(survey_id, distribution_id)
      response = QualtricsAPI.connection(self).get(endpoint)
      parse_page(response)
    end

    private

    def build_result(element)
      QualtricsAPI::DistributionLink.new(element)
    end

    def list_endpoint(survey_id, distribution_id)
      "distributions/#{distribution_id}/links?surveyId=#{survey_id}"
    end
  end
end
