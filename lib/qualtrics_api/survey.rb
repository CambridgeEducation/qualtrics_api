module QualtricsAPI
  class Survey
    include Virtus.value_object

    attribute :connection
    attribute :id, String
    attribute :name, String
    attribute :owner_id, String
    attribute :last_modified, String
    attribute :created_at, String
    attribute :status, String

    attr_accessor :id, :name, :owner_id, :last_modified, :status, :created_at

    def initialize(options = {})
      attributes_mappings.each do |key, qualtrics_key|
        instance_variable_set "@#{key}", options[qualtrics_key]
      end
      super
    end

    def export_responses(export_options = {})
      QualtricsAPI::Services::ResponseExportService.new(export_options.merge(survey_id: id, connection: connection))
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
