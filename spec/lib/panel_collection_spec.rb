require 'spec_helper'

describe QualtricsAPI::PanelCollection do
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
      
        it 'raises bad request error' do
          expect { result }.to raise_error(QualtricsAPI::BadRequestError)
        end
      end
    end
    describe "#each_page" do
      describe "when success" do
        let!(:result) do
          VCR.use_cassette("panel_collection_fetch_success") do
            subject.each_page do |page|
              return page
            end
          end
        end

        it "populates the collection" do
          expect(result.size).to eq 1
          expect(result.first).to be_a QualtricsAPI::Panel
        end
      end

      describe "when failed" do
        it "raises error and does not reset panels" do
          expect do
            VCR.use_cassette("panel_collection_fetch_fail") do
              subject.each_page
            end
          end.to raise_error(QualtricsAPI::BadRequestError)
        end
      end
    end
  end
end
