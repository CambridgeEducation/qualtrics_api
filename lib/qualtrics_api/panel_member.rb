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

    def to_create_json
      attributes(attributes_for_create).select{ |k,v| k }.to_json
    end

    alias_method :super_attributes, :attributes

    def attributes(attrs = attributes_for_save)
      Hash[super_attributes.map { |k, v| [attrs[k], v] }].delete_if { |_k, v| v.nil? }
    end

    private

    def attributes_for_save
      {
        :id => "recipientID",
        :first_name => "firstName",
        :last_name => "lastName",
        :email => "email",
        :language => "language",
        :unsubscribed => 'unsubscribed',
        :external_reference => "externalReference",
        :embeded_data => "embeddedData"
      }
    end

    def attributes_for_create
      attrs = attributes_for_save
      attrs.delete(:id)
      attrs.merge({ :external_reference => "externalDataRef" })
    end

    def attributes_mappings
      {
        :id => "panelMemberId",
        :first_name => "firstName",
        :last_name => "lastName",
        :external_reference => "externalDataReference",
        :embeded_data => "embeddedData"
      }
    end
  end
end
