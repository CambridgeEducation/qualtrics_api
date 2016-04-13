require 'spec_helper'

describe QualtricsAPI::PanelMemberCollection do
  it "has no @page when initialized" do
    expect(subject.page).to eq []
  end

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
        before do
          expect(subject.page.size).to eq 0
        end

        let!(:result) do
          VCR.use_cassette("panel_member_collection_fetch_success") do
            subject.fetch
          end
        end

        it "populates the collection" do
          expect(subject.page.size).to eq 1
          expect(subject.first).to be_a QualtricsAPI::PanelMember
        end

        it "returns itself" do
          expect(result).to eq subject
        end
      end

      describe "when failed" do
        it "raise error and does not change panels" do
          subject.instance_variable_set :@page, [QualtricsAPI::PanelMember.new({})]
          expect do
            VCR.use_cassette("panel_member_collection_fetch_fail") do
              expect { subject.fetch }.to raise_error
            end
          end.not_to change { subject.page }
        end
      end
    end

    describe "#create" do
      let(:result) do
        VCR.use_cassette(cassette, record: :once) do
          QualtricsAPI.panels.find('ML_0APx3C4rmHER6w5').members.create(panel_members)
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
          expect { result }.to raise_error
        end
      end
    end
  end

  describe 'equality' do
    subject { described_class.new(page: [QualtricsAPI::PanelMember.new("recipientID" => "p1"), QualtricsAPI::PanelMember.new("recipientID" => "p1")]) }
    context 'when same' do
      it 'returns true' do
        expect(subject).to eq(described_class.new(page: subject.page))
      end
    end
  
    context 'when different' do
      it 'returns false' do
        expect(subject).not_to eq(described_class.new)
      end
    end
  end
end
