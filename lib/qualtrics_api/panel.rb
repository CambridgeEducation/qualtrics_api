module QualtricsAPI

  class Panel
    include Virtus.value_object

    attribute :connection
    attribute :id, String
    attribute :library_id, String
    attribute :name, String
    attribute :category, String

    def initialize(options = {})
      attributes_mappings.each do |key, qualtrics_key|
        instance_variable_set "@#{key}", options[qualtrics_key]
      end
      super
    end

    private

    def attributes_mappings
      {
        :id => "panelId",
        :library_id => "libraryId",
        :name => "name",
        :category => "category"
      }
    end
  end
end
