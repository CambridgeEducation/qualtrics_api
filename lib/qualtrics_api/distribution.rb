module QualtricsAPI
  class Distribution < BaseModel
    values do
      attribute :id, String
      attribute :action, String
      attribute :survey_id, String
      attribute :mailing_list_id, String
      attribute :description, String
      attribute :expiration_date, DateTime
      attribute :link_type, String
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
        :action => "action",
        :survey_id => "surveyId",
        :mailing_list_id => "mailingListId",
        :description => "description",
        :expiration_date => "expirationDate",
        :link_type => 'linkType'
      }
    end

    def attributes_for_create
      attrs = attributes_for_save
      attrs.delete(:id)
      attrs
    end

    def attributes_mappings
      {
        :id => "id",
        :action => "action",
        :survey_id => "surveyId",
        :mailing_list_id => "mailingListId",
        :description => "description",
        :expiration_date => "expirationDate",
        :link_type => 'linkType'
      }
    end
  end
end
