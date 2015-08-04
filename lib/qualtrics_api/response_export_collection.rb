module QualtricsAPI
  class ResponseExportCollection
    extend Forwardable
    include Enumerable
    include Virtus.value_object

    values do
      attribute :all, Array, :default => []
    end

    def_delegator :all, :each
    def_delegator :all, :size

    def [](export_id)
      find(export_id)
    end
    
    def find(export_id)
      @all.detect do |response_export|
        response_export.id == export_id
      end || QualtricsAPI::ResponseExport.new(:id => export_id)
    end
  end
end
