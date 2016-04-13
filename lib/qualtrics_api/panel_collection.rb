module QualtricsAPI
  class PanelCollection < BaseCollection
    values do
      attribute :page, Array, :default => []
    end

    def fetch()
      @page = []
      parse_fetch_response(QualtricsAPI.connection(self).get('mailinglists'))
      self
    end

    def [](panel_id)
      find(panel_id)
    end

    def find(panel_id)
      @page.detect do |panel|
        panel.id == panel_id
      end || QualtricsAPI::Panel.new("panelId" => panel_id).propagate_connection(self)
    end

    private

    def parse_fetch_response(response)
      @page = response.body["result"]["elements"].map do |elements|
        QualtricsAPI::Panel.new(elements).propagate_connection(self)
      end
    end
  end
end
