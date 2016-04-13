module QualtricsAPI
  class PanelCollection < BaseCollection
    values do
      attribute :page, Array, :default => []
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
  
    def build_result(element)
      QualtricsAPI::Panel.new(element)
    end

    def list_endpoint
      'mailinglists'
    end
  end
end
