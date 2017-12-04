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

    describe "#create_completed_response_subscription" do
      it "creates a subscription to the completedResponse event of the survey id specified" do
        VCR.use_cassette("event_subscription_create_response_sub") do
          survey_id = 'SV_SOME_SURVEY_ID'
          url = 'https://some.url.fake'
          result = subject.create_completed_response_subscription(url, survey_id)
          expect(result).to be_a QualtricsAPI::EventSubscription
          expect(result.id).to_not be_nil
          expect(result.publication_url).to eq url
          expect(result.topics).to eq "surveyengine.completedResponse.#{survey_id}"
        end
      end
    end

    describe "#create_completed_response_subscription" do
      it "creates a subscription to the partialResponse event of the survey id specified" do
        VCR.use_cassette("event_subscription_create_partial_response_sub") do
          survey_id = 'SV_ANOTHER_SURVEY'
          url = 'https://request.url.fake'
          result = subject.create_partial_response_subscription(url, survey_id)
          expect(result).to be_a QualtricsAPI::EventSubscription
          expect(result.id).to_not be_nil
          expect(result.publication_url).to eq url
          expect(result.topics).to eq "surveyengine.partialResponse.#{survey_id}"
        end
      end
    end
  end

  describe "#delete" do
    it "deletes the subscription specified" do
      VCR.use_cassette("event_subscription_delete_one") do
        sub_id = 'SUB_5pPHcNfCaiADoFf'
        subject.delete(sub_id)
        #QualtricsAPI.event_subscriptions.delete(sub_id)
        expect {
          subject.find(sub_id)
          #QualtricsAPI.event_subscriptions.find(sub_id)
        }.to raise_error(QualtricsAPI::NotFoundError)
      end
    end
  end

  describe "#delete_all" do
    it "deletes all subscriptions" do
      VCR.use_cassette("event_subscription_delete_all") do
        expect(subject.all.size).to eq 3
        subject.delete_all
        expect(subject.all.size).to eq 0
      end
    end
  end

end