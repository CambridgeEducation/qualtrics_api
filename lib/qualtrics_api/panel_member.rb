module QualtricsAPI
  class PanelMember
    include Virtus.value_object

    attribute :connection
    attribute :id, String
    attribute :first_name, String
    attribute :last_name, String
    attribute :email, String
    attribute :external_data_reference, String
    attribute :embeded_data, Hash

    def initialize(options = {})
      attributes_mappings.each do |key, qualtrics_key|
        instance_variable_set "@#{key}", options[qualtrics_key]
      end
      super
    end

    private

    def attributes_mappings
      {
        :id => "panelMemberId",
        :first_name => "firstName",
        :last_name => "lastName",
        :external_data_reference => "externalDataReference",
        :embeded_data => "embeddedData"
      }
    end
  end
end
