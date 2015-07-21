module QualtricsAPI
  module Extensions
    module SerializableModel

      def self.included(klass)
        klass.send :alias_method, :as_json, :attributes
      end

      def to_json
        attributes.to_json
      end

    end
  end
end
