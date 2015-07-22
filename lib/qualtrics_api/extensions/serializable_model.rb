module QualtricsAPI
  module Extensions
    module SerializableModel
      def self.included(klass)
        klass.send :alias_method, :as_json, :attributes
      end

      def to_json(options = {})
        attributes.to_json(options)
      end
    end
  end
end
