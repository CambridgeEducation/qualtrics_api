require "qualtrics_api/version"
require "qualtrics_api/url"
require "qualtrics_api/client"

module QualtricsAPI

  def self.new(token)
    Client.new(api_token: token)
  end

end
