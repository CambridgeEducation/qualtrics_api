module QualtricsAPI
  class PanelMemberCollection < BaseCollection
    values do
      attribute :id, String
      attribute :page, Array, :default => []
    end
  
    def create(panel_members)
      payload = {
        contacts: Faraday::UploadIO.new(StringIO.new(panel_members.to_json), 'application/json', 'contacts.json')
      }
      res = QualtricsAPI.connection(self)
                        .post("mailinglists/#{id}/contactimports", payload)
                        .body["result"]
      import_id = res['id']
      QualtricsAPI::PanelImport.new(id: import_id, panel_id: id).propagate_connection(self)
    end

    def [](member_id)
      find(member_id)
    end
    
    def find(member_id)
      @page.detect do |panel_member|
        panel_member.id == member_id
      end || QualtricsAPI::PanelMember.new(:id => member_id).propagate_connection(self)
    end

    private
  
    def build_result(element)
      QualtricsAPI::PanelMember.new(element)
    end

    def list_endpoint
      "mailinglists/#{id}/contacts"
    end
  end
end
