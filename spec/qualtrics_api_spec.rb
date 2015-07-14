require 'spec_helper'

describe QualtricsAPI do
  describe "#new" do
    subject { QualtricsAPI }

    it "initializes a Client with the token passed" do
      expect(subject).to be_kind_of(QualtricsAPI::Client)
    end
  end
end
