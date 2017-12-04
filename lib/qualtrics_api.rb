require 'json'
require 'virtus'
require "faraday"
require "faraday_middleware"

require "qualtrics_api/version"
require "qualtrics_api/request_error_handler"

require "qualtrics_api/configurable"
require "qualtrics_api/connectable"
require "qualtrics_api/client"

require "qualtrics_api/extensions/serializable_model"
require "qualtrics_api/extensions/serializable_collection"

require "qualtrics_api/base_model"
require "qualtrics_api/base_collection"

require "qualtrics_api/survey"
require "qualtrics_api/survey_collection"
require "qualtrics_api/response_export"
require "qualtrics_api/response_export_collection"
require "qualtrics_api/panel"
require "qualtrics_api/panel_collection"
require "qualtrics_api/panel_member"
require "qualtrics_api/panel_member_collection"
require "qualtrics_api/panel_import"

require "qualtrics_api/services/response_export_service"

module QualtricsAPI
  class << self
    include QualtricsAPI::Configurable
    extend Forwardable

    def_delegator :client, :surveys
    def_delegator :client, :response_exports
    def_delegator :client, :panels

    def connection(parent = nil)
      return parent.connection if parent && parent.connection
      client.connection
    end

    def url(data_center_id = self.data_center_id)
      "https://#{data_center_id}.qualtrics.com:443/API/v3/"
    end

    private

    def client
      @client ||= QualtricsAPI::Client.new(QualtricsAPI.api_token, QualtricsAPI.data_center_id)
    end
  end
end
