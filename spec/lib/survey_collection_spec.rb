require 'spec_helper'

describe QualtricsAPI::SurveyCollection do

  let(:connection) { double('connection') }

  subject { described_class.new connection: connection, scope_id: "fake_scopeId" }

  it "has a scope_id" do
    expect(subject.scope_id).to eq "fake_scopeId"
  end

  it "has no @all when initialized" do
    expect(subject.all).to eq []
  end

  it "can assign scope_id" do
    expect(subject).to respond_to :scope_id=
  end

  it "takes a connection" do
    expect(subject.instance_variable_get(:@conn)).to eq connection
  end

  describe "#query_attributes" do
    it "returns only scope_id" do
      expect(subject.query_attributes.size).to eq 1
      expect(subject.query_attributes[:scope_id]).to eq "fake_scopeId"
    end
  end

  describe "integration" do
    let(:client) { QualtricsAPI.new TEST_API_TOKEN }

    subject { described_class.new connection: client.connection }

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

        it "passes down the connection" do
          expect(subject.all.first.instance_variable_get(:@conn)).to eq client.connection
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
              subject.fetch(scope_id: "fake") rescue nil
            end
          }.to change { subject.all }.to([])
        end
      end

      describe "with options" do
        it "updates the options" do
          VCR.use_cassette("survey_collection_fetch_with_scopeId_success") do
            expect(subject.scope_id).to be_nil
            subject.fetch(scope_id: "UR_3fnAz35QCGlr725")
            expect(subject.scope_id).to eq "UR_3fnAz35QCGlr725"
          end
        end
      end
    end

  end

end
