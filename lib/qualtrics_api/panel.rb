module QualtricsAPI
  class Panel < BaseModel
    values do
      attribute :id, String
      attribute :library_id, String
      attribute :name, String
      attribute :category, String
    end

    def members(options = {})
      @members ||= QualtricsAPI::PanelMemberCollection.new(options.merge(id: id)).propagate_connection(self)
    end

    def import_members(mbs)
      members.import_members(mbs)
    end

    def create(member)
      members.create(member)
    end

    private

    def attributes_mappings
      {
        :id => "panelId",
        :library_id => "libraryId",
        :name => "name"
      }
    end
  end
end
