module QualtricsAPI
  class PanelCollection < BaseCollection
    values do
      attribute :all, Array, :default => []
    end

    def fetch(_options = {})
      @all = []
      parse_fetch_response(QualtricsAPI.connection(self).get('panels'))
      self
    end

    def [](panel_id)
      find(panel_id)
    end

    def find(panel_id)
      @all.detect do |panel|
        panel.id == panel_id
      end || QualtricsAPI::Panel.new("panelId" => panel_id).propagate_connection(self)
    end

    private

    def parse_fetch_response(response)
      @all = response.body["result"].map do |result|
        QualtricsAPI::Panel.new(result).propagate_connection(self)
      end
    end
  end
end
