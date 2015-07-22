module QualtricsAPI
  module Configurable
    attr_accessor :api_token

    def configure
      yield self
      self
    end
  end
end
