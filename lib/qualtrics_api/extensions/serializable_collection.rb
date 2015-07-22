module QualtricsAPI
  module Extensions
    module SerializableCollection
      def as_json(options = {})
        @all.map do |model|
          model.as_json(options)
        end
      end

      def to_json(options = {})
        as_json.to_json(options)
      end
    end
  end
end
