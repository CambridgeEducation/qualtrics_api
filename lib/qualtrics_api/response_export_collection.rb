module QualtricsAPI
  class ResponseExportCollection
    include Virtus.value_object
    include QualtricsAPI::Connectable

    def [](export_id)
      find(export_id)
    end
    
    def find(export_id)
      QualtricsAPI::ResponseExport.new(:id => export_id).propagate_connection(self)
    end
  end
end
