module QualtricsAPI
  class PanelMember
    include Virtus.value_object

    attribute :connection
    attribute :id, String
    attribute :first_name, String
    attribute :last_name, String
    attribute :email, String
    attribute :language, String
    attribute :unsubscribed, Integer
    attribute :external_data_reference, String
    attribute :embeded_data, Hash

    def initialize(options = {})
      attributes_mappings.each do |key, qualtrics_key|
        instance_variable_set "@#{key}", options[qualtrics_key]
      end
      super
    end

    def to_json(_options = {})
      serialized_attributes.to_json
    end

    private

    def serialized_attributes
      Hash[attributes.map { |k, v| [attributes_mappings[k] || k, v] }].tap do |h|
        h.delete(:connection)
      end
    end

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
