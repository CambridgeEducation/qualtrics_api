module QualtricsAPI

  class PanelCollection
    extend Forwardable
    include Enumerable
    include Virtus.value_object

    attribute :connection
    attribute :all, Array, :default => []

    def_delegator :all, :each
    def_delegator :all, :size

    def fetch(options = {})
      @all = []
      parse_fetch_response(connection.get('panels'))
      self
    end

    def [](panel_id)
      find(panel_id)
    end

    def find(panel_id)
      @all.select do |panel|
        panel.id == panel_id
      end.first || QualtricsAPI::Panel.new("panelId" => panel_id, connection: connection)
    end

    private

    def parse_fetch_response(response)
      @all = response.body["result"].map do |result|
        QualtricsAPI::Panel.new result.merge(connection: connection)
      end
    end
  end
end
