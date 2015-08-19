module QualtricsAPI
  class ResponseExportCollection < BaseCollection
    values do
      attribute :all, Array, :default => []
    end

    def [](export_id)
      find(export_id)
    end
    
    def find(export_id)
      @all.detect do |response_export|
        response_export.id == export_id
      end || QualtricsAPI::ResponseExport.new(:id => export_id).propagate_connection(self)
    end
  end
end
