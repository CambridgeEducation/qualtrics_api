require 'spec_helper'

describe QualtricsAPI::EventSubscription do
  let(:event_subscription) do
    {
      "id" => "SUB_012345678912345",
      "scope" => "exampleorganizationid",
      "topics" => "controlpanel.activateSurvey",
      "publicationUrl" => "https://www.example.com/pub",
      "encrypted" => false,
      "successfulCalls" => 3
    }
  end

  subject { described_class.new event_subscription }

  it "has an id" do
    expect(subject.id).to eq "SUB_012345678912345"
  end
  
  it "has scope" do
    expect(subject.scope).to eq "exampleorganizationid"
  end

  it "has topics" do
    expect(subject.topics).to eq "controlpanel.activateSurvey"
  end

  it "has publicationUrl" do
    expect(subject.publication_url).to eq "https://www.example.com/pub"
  end

  it "shows if encrypted" do
    expect(subject.encrypted?).to be false
  end

  it "shows number of successful calls" do
    expect(subject.successful_calls).to eq 3
  end

  describe "#delete" do
    it "deletes the subscription" do
      VCR.use_cassette("event_subscription_delete") do
        sub_id = 'SUB_2i7QDi3PXEK4eqx'
        subscription = QualtricsAPI.event_subscriptions.find(sub_id)
        result = subscription.delete
        expect(result).to be_truthy
        expect {
          QualtricsAPI.event_subscriptions.find(sub_id)
        }.to raise_error(QualtricsAPI::NotFoundError)
      end
    end
  end
end