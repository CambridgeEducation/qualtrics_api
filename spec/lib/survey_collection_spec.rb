require 'spec_helper'

describe QualtricsAPI::SurveyCollection do
  it "has no @page when initialized" do
    expect(subject.page).to eq []
  end

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
        before do
          expect(subject.page.size).to eq 0
        end

        let!(:result) do
          VCR.use_cassette("survey_collection_fetch_sucess") do
            subject.fetch
          end
        end

        it "populates the collection" do
          expect(subject.page.size).to eq 1
          expect(subject.first).to be_a QualtricsAPI::Survey
        end

        it "returns itself" do
          expect(result).to eq subject
        end
      end

      describe "when failed" do
        it "raises error and does not reset surveys" do
          subject.instance_variable_set :@page, [QualtricsAPI::Survey.new({})]
          expect do
            VCR.use_cassette("survey_collection_fetch_fail") do
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
  
    describe 'pagination' do
      describe '#first_page'    
      it 'fetches pages from list endpoint' do
        VCR.use_cassette("survey_collection_fetch_sucess") do
          subject.fetch
          expect(subject.fetched).to be_truthy
          expect(subject.page.size).to eq(1)
          expect(subject.last_page?).to be_falsey
        end
      end

      it 'fetches pages from next page' do
        VCR.use_cassette("survey_collection_fetch_sucess") do
          subject.fetch.fetch
          expect(subject.fetched).to be_truthy
          expect(subject.page.size).to eq(0)
          expect(subject.last_page?).to be_truthy
        end
      end
    
      it 'does nothing when on last page' do
        VCR.use_cassette("survey_collection_fetch_sucess") do
          subject.fetch.fetch.fetch
          expect(subject.fetched).to be_truthy
          expect(subject.page.size).to eq(0)
          expect(subject.last_page?).to be_truthy
        end
      end
    end
  end

  describe 'equality' do
    subject { described_class.new(page: [QualtricsAPI::Survey.new("id" => "s1"), QualtricsAPI::Survey.new("id" => "s2")]) }
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
