module QualtricsAPI
  class DistributionLinkCollection < BaseCollection
    def initialize(survey_id, distribution_id)
      @survey_id = survey_id
      @distribution_id = distribution_id
    end

    def [](distribution_link_id)
      find(distribution_link_id)
    end

    def find(distribution_link_id)
      raise NotImplementedError
    end

    private

    def build_result(element)
      QualtricsAPI::DistributionLink.new(element)
    end

    def list_endpoint
      "distributions/#{@distribution_id}/links?surveyId=#{@survey_id}"
    end
  end
end
