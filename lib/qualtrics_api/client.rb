module QualtricsAPI
  class Client
    attr_reader :api_token

    def initialize(options = {})
      @api_token = options[:api_token]
    end

  end
end
