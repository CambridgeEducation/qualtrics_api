require 'spec_helper'

describe QualtricsAPI::Client do

  subject { QualtricsAPI::Client.new(:api_token => "someToken") }

  it "has an api token" do
    expect(subject.api_token).to eq "someToken"
  end

  it "does not allow changing the token once initialized" do
    expect(subject).to_not respond_to(:api_token=)
  end

end
