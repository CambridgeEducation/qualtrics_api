module QualtricsAPI
  module Extensions
    module SerializableCollection

      def as_json
        @all.map do |model|
          model.as_json
        end
      end

      def to_json
        as_json.to_json
      end

    end
  end
end

