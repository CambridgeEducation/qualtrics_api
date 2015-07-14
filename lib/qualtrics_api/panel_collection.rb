module QualtricsAPI
  class PanelCollection
    extend Forwardable
    include Enumerable
    include Virtus.value_object

    attribute :all, Array, :default => []

    def_delegator :all, :each
    def_delegator :all, :size

    def fetch(_options = {})
      @all = []
      parse_fetch_response(QualtricsAPI.connection.get('panels'))
      self
    end

    def [](panel_id)
      find(panel_id)
    end

    def find(panel_id)
      @all.detect do |panel|
        panel.id == panel_id
      end || QualtricsAPI::Panel.new("panelId" => panel_id)
    end

    private

    def parse_fetch_response(response)
      @all = response.body["result"].map do |result|
        QualtricsAPI::Panel.new result
      end
    end
  end
end
