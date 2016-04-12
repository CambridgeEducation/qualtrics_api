module QualtricsAPI
  class PanelMemberCollection < BaseCollection
    values do
      attribute :id, String
      attribute :all, Array, :default => []
    end
  
    def fetch(_options = {})
      @all = []
      parse_fetch_response(QualtricsAPI.connection(self).get("mailinglists/#{id}/contacts"))
      self
    end

    def create(panel_members)
      res = QualtricsAPI.connection(self)
            .post("mailinglists/#{id}/contactimports", QualtricsAPI.connection(self).params.merge(panelMembers: panel_members.to_json))
            .body["result"]
      import_id = res['importStatus'].split('/').last
      QualtricsAPI::PanelImport.new(id: import_id, panel_id: id).propagate_connection(self)
    end

    def [](member_id)
      find(member_id)
    end
    
    def find(member_id)
      @all.detect do |panel_member|
        panel_member.id == member_id
      end || QualtricsAPI::PanelMember.new(:id => member_id).propagate_connection(self)
    end

    private

    def parse_fetch_response(response)
      @all = response.body["result"]["elements"].map do |element|
        QualtricsAPI::PanelMember.new(element).propagate_connection(self)
      end
    end
  end
end
