module QualtricsAPI
  class ResponseExportCollection
    extend Forwardable
    include Enumerable

    attr_reader :all

    def_delegator :all, :each
    def_delegator :all, :size

    def initialize(options = {})
      @conn = options[:connection]
      @all = []
    end

    def [](export_id); find(export_id); end
    def find(export_id)
      @all.select do |response_export|
        response_export.id == export_id
      end.first || QualtricsAPI::ResponseExport.new(:id => export_id , connection: @conn)
    end

  end
end
