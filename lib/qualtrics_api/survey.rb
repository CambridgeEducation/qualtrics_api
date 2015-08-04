module QualtricsAPI
  class Survey < BaseModel
    values do
      attribute :id, String
      attribute :name, String
      attribute :owner_id, String
      attribute :last_modified, String
      attribute :created_at, String
      attribute :status, String
    end

    def export_responses(export_options = {})
      QualtricsAPI::Services::ResponseExportService.new(export_options.merge(survey_id: id))
    end

    private

    def attributes_mappings
      {
        :id => "id",
        :name => "name",
        :owner_id => "ownerId",
        :last_modified => "lastModified",
        :status => "status",
        :created_at => "SurveyCreationDate"
      }
    end
  end
end
