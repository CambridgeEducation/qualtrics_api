module QualtricsAPI
  class PanelCollection < BaseCollection
    def [](panel_id)
      find(panel_id)
    end

    private
  
    def build_result(element)
      QualtricsAPI::Panel.new(element)
    end

    def list_endpoint
      'mailinglists'
    end

    def endpoint(id)
      "mailinglists/#{id}"
    end
  end
end
