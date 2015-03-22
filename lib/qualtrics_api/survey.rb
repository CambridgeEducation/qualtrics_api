module QualtricsAPI

  class Survey
    attr_accessor :id, :name, :owner_id, :last_modified, :status

    def initialize(attributes, options = {})
      attributes_mappings.each do |key, qualtrics_key|
        instance_variable_set "@#{key}", attributes[qualtrics_key]
      end
      @conn = options[:connection]
    end

    private

    def attributes_mappings
      {
        :id => "id",
        :name => "name",
        :owner_id => "ownerId",
        :last_modified => "lastModified",
        :status => "status"
      }
    end
  end
end
