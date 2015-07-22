module QualtricsAPI
  module Extensions
    module SerializableModel
      def as_json(_options = {})
        attributes
      end

      def to_json(options = {})
        attributes.to_json(options)
      end
    end
  end
end
