require 'spec_helper'

describe QualtricsAPI::SurveyCollection do
  describe "integration" do
    subject { described_class.new }

    describe "#find" do
      let(:result) do
        VCR.use_cassette("survey_find") do
          subject.find(survey_id)
        end
      end

      context 'when exists' do
        let(:survey_id) { 'SV_0fEV92PdRg8a2e9' } 
      
        it 'populates the result' do
          expect(result.attributes).to eq(:id => "SV_0fEV92PdRg8a2e9", :name => "test", :owner_id => "owner_id", :last_modified => nil, :is_active => true)
        end
      end
    
      context 'when does not exists' do
        let(:survey_id) { 'SV_0fEV92PdRg8a2e0' } 
      
        it 'populates the result' do
          expect { result }.to raise_error(QualtricsAPI::NotFoundError)
        end
      end
    end
    
    describe "#fetch" do
      describe "when success" do
        let!(:result) do
          VCR.use_cassette("survey_collection_fetch_sucess") do
            subject.each_page do |page|
              return page
            end
          end
        end

        it "populates the collection" do
          expect(result.size).to eq 1
          expect(result.first).to be_a QualtricsAPI::Survey
        end
      end

      describe "when failed" do
        it "raises error" do
          VCR.use_cassette("survey_collection_fetch_fail") do
            expect { subject.each_page }.to raise_error(QualtricsAPI::NotFoundError)
          end
        end
      end
    end
  
    describe 'pagination' do
      it 'fetches pages from list endpoint' do
        page1 = page2 = nil
        VCR.use_cassette("survey_collection_fetch_sucess") do
          page_no = 0
          subject.each_page do |page|
            if page_no == 0
              page1 = page
            elsif page_no == 1
              page2 = page
            else
              raise 'should not iterate here'
            end
            page_no += 1
          end
          expect(page1).not_to be_nil
          expect(page2).not_to be_nil
        end
      end
    end
  end
end
