module QualtricsAPI
  class PanelMemberCollection < BaseCollection
    values do
      attribute :id, String
    end

    def create(panel_member)
      payload = panel_member.to_create_json
      res = QualtricsAPI.connection(self)
                  .post("mailinglists/#{id}/contacts", payload)
                  .body["result"]
      return QualtricsAPI::PanelMember.new(panel_member.attributes.merge({ id: res['id'] }))
    end
  
    def import_members(panel_members)
      payload = {
        contacts: Faraday::UploadIO.new(StringIO.new(panel_members.to_json), 'application/json', 'contacts.json')
      }
      res = QualtricsAPI.connection(self)
                        .post("mailinglists/#{id}/contactimports", payload)
                        .body["result"]
      import_id = res['id']
      QualtricsAPI::PanelImport.new(id: import_id, panel_id: id).propagate_connection(self)
    end

    def find(id)
      raise QualtricsAPI::NotSupported, 'Find not supported for panel member'
    end

    def [](member_id)
      find(member_id)
    end

    private
  
    def build_result(element)
      QualtricsAPI::PanelMember.new(element)
    end

    def list_endpoint
      "mailinglists/#{id}/contacts"
    end

    def endpoint(member_id)
      "mailinglists/#{id}/contacts/#{member_id}"
    end
  end
end
