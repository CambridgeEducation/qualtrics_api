module QualtricsAPI
  module Extensions
    module SerializableModel
      def as_json(_options = {})
        attributes
      end
    end
  end
end
