require 'spec_helper'

describe QualtricsAPI::EventSubscriptionCollection do
  subject { described_class.new }

  describe "can find subscriptions" do
    it "returns the subscription if exists" do
      VCR.use_cassette("event_subscription_find") do
        subscription_id = "SUB_6XMPw9UoySyGNyl"
        result = subject.find(subscription_id)
        expect(result).to be_a QualtricsAPI::EventSubscription
        expect(result.id).to eq subscription_id
      end
    end

    it "raise an error if not exists" do
      VCR.use_cassette("event_subscription_find_fail") do
        subscription_id = "pewpewpewpew"
        expect {
          subject.find(subscription_id)
        }.to raise_error(QualtricsAPI::NotFoundError)
      end
    end
  end

  describe "#create" do
    it "creates subscription with publication url and topics" do
      VCR.use_cassette("event_subscription_create") do
        result = subject.create('https://some.random.url', 'controlpanel.activateSurvey')
        expect(result).to be_a QualtricsAPI::EventSubscription
        expect(result.id).to_not be_nil
        expect(result.publication_url).to eq 'https://some.random.url'
      end
    end
  end

end