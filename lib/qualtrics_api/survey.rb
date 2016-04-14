module QualtricsAPI
  class Survey < BaseModel
    values do
      attribute :id, String
      attribute :name, String
      attribute :owner_id, String
      attribute :last_modified, String
      attribute :is_active, Boolean
    end

    def export_responses(export_options = {})
      QualtricsAPI::Services::ResponseExportService.new(export_options.merge(survey_id: id)).propagate_connection(self)
    end

    private

    def attributes_mappings
      {
        :id => "id",
        :name => "name",
        :owner_id => "ownerId",
        :last_modified => "lastModified",
        :is_active => "isActive"
      }
    end
  end
end
