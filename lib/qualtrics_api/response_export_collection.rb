module QualtricsAPI
  class ResponseExportCollection
    extend Forwardable
    include Enumerable
    include Virtus.value_object

    attribute :connection
    attribute :all, Array, :default => []

    def_delegator :all, :each
    def_delegator :all, :size

    def [](export_id)
      find(export_id)
    end
    
    def find(export_id)
      @all.select do |response_export|
        response_export.id == export_id
      end.first || QualtricsAPI::ResponseExport.new(:id => export_id, connection: connection)
    end
  end
end
