require 'qualtrics_api'
require 'vcr'

TEST_API_TOKEN = "6Wpo0Vsx1cN1kcHivCaGTz5IhOvchLrg1o4L0KOZ".freeze

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :faraday
end

QualtricsAPI.configure do |config|
  config.api_token = TEST_API_TOKEN
end
