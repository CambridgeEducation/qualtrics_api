module QualtricsAPI
  class DistributionLink < BaseModel
    values do
      attribute :status, String
      attribute :email, String
      attribute :first_name, String
      attribute :last_name, String
      attribute :link_expiration, DateTime
      attribute :link, String
      attribute :exceeded_contact_frequency, Boolean
      attribute :unsubscribed, Boolean
      attribute :contact_id, String
      attribute :external_data_reference, String
    end

    private

    def attributes_mappings
      {
        :status => "status",
        :email => "email",
        :first_name => "firstName",
        :last_name => "lastName",
        :link_expiration => "linkExpiration",
        :link => "link",
        :exceeded_contact_frequency => "exceededContactFrequency",
        :unsubscribed => "unsubscribed",
        :contact_id => "contactId",
        :external_data_reference => "externalDataReference"
      }
    end
  end
end
