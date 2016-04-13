require 'spec_helper'

describe QualtricsAPI::PanelCollection do
  it "has no @page when initialized" do
    expect(subject.page).to eq []
  end

  describe "integration" do
    describe "#find" do
      let(:result) do
        VCR.use_cassette("panel_find") do
          subject.find(panel_id)
        end
      end

      context 'when exists' do
        let(:panel_id) { 'ML_00c5BS2WNUCWQIt' } 
      
        it 'populates the result' do
          expect(result.attributes).to eq(:id => "ML_00c5BS2WNUCWQIt", :library_id => "UR_5dURLpfp5tm43EV", :name => "Panel name", :category => "Unassigned")
        end
      end
    
      context 'when does not exists' do
        let(:panel_id) { 'ML_00c5BS2WNUCWQI0' } 
      
        it 'populates the result' do
          expect { result }.to raise_error(QualtricsAPI::BadRequestError)
        end
      end
    end
    describe "#fetch" do
      describe "when success" do
        before do
          expect(subject.page.size).to eq 0
        end

        let!(:result) do
          VCR.use_cassette("panel_collection_fetch_success") do
            subject.fetch
          end
        end

        it "populates the collection" do
          expect(subject.page.size).to eq 1
          expect(subject.first).to be_a QualtricsAPI::Panel
        end

        it "returns itself" do
          expect(result).to eq subject
        end
      end

      describe "when failed" do
        it "raises error and does not reset panels" do
          subject.instance_variable_set :@page, [QualtricsAPI::Panel.new({})]
          expect do
            VCR.use_cassette("panel_collection_fetch_fail") do
              begin
                subject.fetch
              rescue
                nil
              end
            end
          end.not_to change { subject.page }
        end
      end
    end
  end

  describe 'equality' do
    subject { described_class.new(page: [QualtricsAPI::Panel.new("panelId" => "p1"), QualtricsAPI::Panel.new("panelId" => "p2")]) }
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
