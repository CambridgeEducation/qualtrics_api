module QualtricsAPI
  module Configurable
    attr_accessor :api_token
    attr_accessor :data_center_id

    def configure
      yield self
      self
    end

    def data_center_id
      @data_center_id || 'co1'
    end
  end
end
