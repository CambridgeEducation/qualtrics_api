require 'json'
require 'virtus'
require "faraday"
require "faraday_middleware"

require "qualtrics_api/version"
require "qualtrics_api/url"

require "qualtrics_api/request_error_handler"

require "qualtrics_api/configurable"
require "qualtrics_api/client"

require "qualtrics_api/extensions/serializable_model"

require "qualtrics_api/base_model"

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
    include QualtricsAPI::Client
  end
end
