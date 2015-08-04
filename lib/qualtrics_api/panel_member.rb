module QualtricsAPI
  class PanelMember < BaseModel
    values do
      attribute :id, String
      attribute :first_name, String
      attribute :last_name, String
      attribute :email, String
      attribute :language, String
      attribute :unsubscribed, Integer
      attribute :external_reference, String
      attribute :embeded_data, Hash
    end

    def to_json(_options = {})
      attributes.to_json
    end

    alias_method :super_attributes, :attributes

    def attributes
      Hash[super_attributes.map { |k, v| [mapped_and_uppercased_attribute(k), v] }].delete_if { |_k, v| v.nil? }
    end

    private

    def mapped_and_uppercased_attribute(attribute)
      (attributes_mappings[attribute] || attribute).to_s.tap do |a|
        a[0] = a[0].upcase
      end
    end

    def attributes_mappings
      {
        :id => "recipientID",
        :first_name => "firstName",
        :last_name => "lastName",
        :external_reference => "externalReference",
        :embeded_data => "embeddedData"
      }
    end
  end
end
