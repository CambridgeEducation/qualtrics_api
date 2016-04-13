module QualtricsAPI
  class ResponseExportCollection < BaseCollection
    values do
      attribute :page, Array, :default => []
    end

    def [](export_id)
      find(export_id)
    end
    
    def find(export_id)
      @page.detect do |response_export|
        response_export.id == export_id
      end || QualtricsAPI::ResponseExport.new(:id => export_id).propagate_connection(self)
    end
  end
end
