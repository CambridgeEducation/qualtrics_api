require 'spec_helper'

describe QualtricsAPI do
  describe "#new" do
    subject { QualtricsAPI }

    it 'two clients have different connection' do
      client_1 = QualtricsAPI::Client.new('some_id', 'co1')
      client_2 = QualtricsAPI::Client.new('other_id', 'co2')
      expect(client_1.connection).not_to eq(client_2.connection)
    end

    it 'reuses connection if globally configured' do
      expect(QualtricsAPI.connection).to eq(QualtricsAPI.connection)
    end

    it 'does not reuse connection with client' do
      client = QualtricsAPI::Client.new('some_id', 'co1')
      expect(client.connection).not_to eq(QualtricsAPI.connection)
    end

    context 'chains' do
      it 'does propagate default connection' do
        members = VCR.use_cassette('panel_member_collection_create_success') do
          QualtricsAPI.panels.find('ML_bC2c5xBz1DxyOYB').members
        end
        expect(members.connection).to eq(QualtricsAPI.connection)
      end

      context 'with client' do
        let(:client) { QualtricsAPI::Client.new(TEST_API_TOKEN, 'co1') }
        let(:members) do
          VCR.use_cassette('panel_member_collection_create_success') do
            client.panels.find('ML_bC2c5xBz1DxyOYB').members
          end
        end

        it 'has client connection' do
          expect(client.connection).not_to be_nil
        end

        it 'has propagated exception to members' do
          expect(members.connection).to eq(client.connection)
        end

        context 'with different client' do
          let(:client_2) { QualtricsAPI::Client.new(TEST_API_TOKEN, 'co1') }
          let(:members_2) do
            VCR.use_cassette('panel_member_collection_create_success') do
              client_2.panels.find('ML_bC2c5xBz1DxyOYB').members
            end
          end

          it 'has propagated exception to members' do
            expect(members_2.connection).to eq(client_2.connection)
          end

          it 'does not conflict with different client' do
            expect(client_2.connection).not_to eq(client.connection)
          end
        end
      end
    end
  end
end
