require 'spec_helper'

describe QualtricsAPI::Client do

  subject { QualtricsAPI::Client.new(:api_token => "someToken") }

  it "has an api token" do
    expect(subject.api_token).to eq "someToken"
  end

  it "does not allow changing the token once initialized" do
    expect(subject).to_not respond_to(:api_token=)
  end

  describe "#response_exports" do
    it "returns a ResponseExportCollection" do
      expect(subject.response_exports).to be_a QualtricsAPI::ResponseExportCollection
    end

    it "sets connection" do
      expect(subject.surveys.instance_variable_get(:@conn)).to eq subject.connection
    end

    it "caches the collection" do
      expect(subject.response_exports.object_id).to eq subject.response_exports.object_id
    end
  end

  describe "#surveys" do
    it "returns a SurveyCollection" do
      expect(subject.surveys).to be_a QualtricsAPI::SurveyCollection
    end

    it "sets connection" do
      expect(subject.surveys.instance_variable_get(:@conn)).to eq subject.connection
    end

    it "assigns scope_id if passed" do
      expect(subject.surveys(:scope_id => "someId").scope_id).to eq "someId"
    end

    it "caches the surveys" do
      expect(subject.surveys.object_id).to eq subject.surveys.object_id
    end
  end

end
