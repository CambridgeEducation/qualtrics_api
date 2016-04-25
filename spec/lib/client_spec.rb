require 'spec_helper'

describe QualtricsAPI::Client do
  subject { QualtricsAPI }

  describe "#response_exports" do
    it "returns a ResponseExportCollection" do
      expect(subject.response_exports).to be_a QualtricsAPI::ResponseExportCollection
    end
  end

  describe "#surveys" do
    it "returns a SurveyCollection" do
      expect(subject.surveys).to be_a QualtricsAPI::SurveyCollection
    end
  end

  describe "#initialize" do
    subject { QualtricsAPI::Client }

    it "fails if api_token not provided" do
      expect { subject.new(nil) }.to raise_error('Please provide api token!')
    end

    it 'establishes connection when api_token' do
      subject.new('sample_token')
    end
  end
end
