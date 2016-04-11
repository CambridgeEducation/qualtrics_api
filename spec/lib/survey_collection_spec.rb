require 'spec_helper'

describe QualtricsAPI::SurveyCollection do
  it "has no @all when initialized" do
    expect(subject.all).to eq []
  end

  describe "#find, #[]" do
    let(:survey_1) { QualtricsAPI::Survey.new "id" => "s1" }
    let(:survey_2) { QualtricsAPI::Survey.new "id" => "s2" }

    it "finds the survey by id" do
      subject.instance_variable_set :@all, [survey_1, survey_2]
      expect(subject.find("s1")).to eq survey_1
      expect(subject["s2"]).to eq survey_2
    end

    it "returns a new survey with the id" do
      sut = subject["s3"]
      expect(sut).to be_a QualtricsAPI::Survey
      expect(sut.id).to eq "s3"
    end
  end

  describe "integration" do
    subject { described_class.new }

    describe "#fetch" do
      describe "when success" do
        before do
          expect(subject.size).to eq 0
        end

        let!(:result) do
          VCR.use_cassette("survey_collection_fetch_sucess") do
            subject.fetch
          end
        end

        it "populates the collection" do
          expect(subject.size).to eq 1
          expect(subject.first).to be_a QualtricsAPI::Survey
        end

        it "returns itself" do
          expect(result).to eq subject
        end
      end

      describe "when failed" do
        it "resets surveys" do
          subject.instance_variable_set :@all, [QualtricsAPI::Survey.new({})]
          expect {
            VCR.use_cassette("survey_collection_fetch_fail") do
              subject.fetch rescue nil
            end
          }.to change { subject.all }.to([])
        end
      end
    end
  end

  describe 'equality' do
    subject { described_class.new(all: [QualtricsAPI::Survey.new("id" => "s1"), QualtricsAPI::Survey.new("id" => "s2")]) }
    context 'when same' do
      it 'returns true' do
        expect(subject).to eq(described_class.new(all: subject.all))
      end
    end
  
    context 'when different' do
      it 'returns false' do
        expect(subject).not_to eq(described_class.new)
      end
    end
  end
end
