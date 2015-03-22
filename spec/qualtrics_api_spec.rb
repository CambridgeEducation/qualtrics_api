require 'spec_helper'

describe QualtricsAPI do

  describe "#new" do

    subject { QualtricsAPI.new("someToken") }

    it "initializes a Client with the token passed" do
      expect(subject).to be_kind_of(QualtricsAPI::Client)
      expect(subject.api_token).to eq "someToken"
    end
  end

end
