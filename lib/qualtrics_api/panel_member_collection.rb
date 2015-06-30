module QualtricsAPI
  class PanelMemberCollection
    extend Forwardable
    include Enumerable
    include Virtus.value_object

    attribute :connection
    attribute :id, String
    attribute :all, Array, :default => []
  
    def_delegator :all, :each
    def_delegator :all, :size

    def fetch(_options = {})
      @all = []
      parse_fetch_response(connection.get("panels/#{id}/members"))
      self
    end

    def create(panel_members)
      res = connection
            .post("panels/#{id}/members", connection.params.merge(panelMembers: panel_members.to_json))
            .body["result"]
      import_id = res['importStatus'].split('/').last
      QualtricsAPI::PanelImport.new(id: import_id)
    end

    def [](member_id)
      find(member_id)
    end
    
    def find(member_id)
      @all.detect do |panel_member|
        panel_member.id == member_id
      end || QualtricsAPI::PanelMember.new(:id => member_id, connection: connection)
    end

    private

    def parse_fetch_response(response)
      @all = response.body["result"].map do |result|
        QualtricsAPI::PanelMember.new(result.merge(connection: connection))
      end
    end
  end
end
