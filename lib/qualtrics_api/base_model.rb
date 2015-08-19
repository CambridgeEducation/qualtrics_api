module QualtricsAPI
  class BaseModel
    include Virtus.value_object
    include QualtricsAPI::Extensions::SerializableModel
    include QualtricsAPI::Connectable

    def initialize(options = {})
      @connection = options[:connection]
      attributes_mappings.each do |key, qualtrics_key|
        instance_variable_set "@#{key}", options[qualtrics_key]
      end
      super
    end

    private

    def attributes_mappings
      {}
    end
  end
end
