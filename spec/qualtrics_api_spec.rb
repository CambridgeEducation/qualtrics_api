require 'spec_helper'

describe QualtricsAPI do
  describe "#new" do
    subject { QualtricsAPI }

    it 'two clients have different connection' do
      client_1 = QualtricsAPI::Client.new('some_id')
      client_2 = QualtricsAPI::Client.new('other_id')
      expect(client_1.connection).not_to eq(client_2.connection)
    end

    it 'reuses connection if globally configured' do
      QualtricsAPI.configure do |config|
        config.api_token = 'some_id'
      end
      expect(QualtricsAPI.connection).to eq(QualtricsAPI.connection)
    end

    it 'does not reuse connection with client' do
      client = QualtricsAPI::Client.new('some_id')
      QualtricsAPI.configure do |config|
        config.api_token = 'some_id'
      end
      expect(client.connection).not_to eq(QualtricsAPI.connection)
    end
  end
end
