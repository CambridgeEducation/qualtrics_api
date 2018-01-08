require 'spec_helper'

describe QualtricsAPI::PanelMemberCollection do
  describe "integration" do
    subject { described_class.new(id: 'ABCD') }

    describe "#find" do
      let(:result) do
        VCR.use_cassette("survey_find") do
          subject.find(survey_id)
        end
      end

      context 'when exists' do
        let(:survey_id) { 'SV_0fEV92PdRg8a2e9' } 
      
        it 'raises error' do
          expect { result }.to raise_error(QualtricsAPI::NotSupported, 'Find not supported for panel member')
        end
      end
    
      context 'when does not exists' do
        let(:survey_id) { 'SV_0fEV92PdRg8a2e0' } 
      
        it 'raises error' do
          expect { result }.to raise_error(QualtricsAPI::NotSupported, 'Find not supported for panel member')
        end
      end
    end

    describe "#fetch" do
      describe "when success" do
        let!(:result) do
          VCR.use_cassette("panel_member_collection_fetch_success") do
            subject.each_page do |page|
              return page
            end
          end
        end

        it "populates the collection" do
          expect(result.size).to eq 1
          expect(result.first).to be_a QualtricsAPI::PanelMember
        end
      end

      describe "when failed" do
        it "raise error" do
          VCR.use_cassette("panel_member_collection_fetch_fail") do
            expect { subject.each_page }.to raise_error(QualtricsAPI::BadRequestError)
          end
        end
      end
    end

    describe "#import_members" do
      let(:result) do
        VCR.use_cassette(cassette, record: :once) do
          QualtricsAPI.panels.find('ML_0APx3C4rmHER6w5').members.import_members(panel_members)
        end
      end

      describe "when success" do
        let(:cassette) { "panel_member_collection_create_success" }
        let(:panel_members) { [QualtricsAPI::PanelMember.new(first_name: 'Marcin', last_name: 'Naglik', email: 'test@test.com')] }

        it "returns PanelImport" do
          expect(result).to be_a QualtricsAPI::PanelImport
        end

        it "returns PanelImport with id" do
          expect(result.id).to eq('PGRS_4GvIMg79RFEPW4d')
        end

        it "returns PanelImport with panel id" do
          expect(result.panel_id).to eq('ML_0APx3C4rmHER6w5')
        end
      end

      describe "when failed" do
        let(:cassette) { "panel_member_collection_create_fail" }
        let(:panel_members) { [QualtricsAPI::PanelMember.new] }

        it "returns results" do
          expect { result }.to raise_error(QualtricsAPI::BadRequestError)
        end
      end
    end

    describe '#create' do
      let(:result) do
        VCR.use_cassette(cassette, record: :once) do
          QualtricsAPI.panels.find('ML_ez0Gj1S4SX4TZjv').members.create(panel_member)
        end
      end

      describe 'when success' do
        let(:cassette) { 'panel_member_single_create_success' }
        let(:panel_member) { QualtricsAPI::PanelMember.new(first_name: 'test', last_name: 'member', email: 'test@test.com') }

        it 'returns PanelMember' do
          expect(result).to be_a QualtricsAPI::PanelMember
        end

        it 'returns PanelMember with id' do
          expect(result.id).to match(/^MLRP_/)
        end
      end

      describe 'when failed' do
        let(:cassette) { 'panel_member_single_create_failure' }
        let(:panel_member) { QualtricsAPI::PanelMember.new(first_name: 'test', last_name: 'member', email: 'test@test.com') }

        it 'raises exception' do
          expect{result}.to raise_error{QualtricsAPI::NotFoundError}
        end
      end
    end
  end
end
