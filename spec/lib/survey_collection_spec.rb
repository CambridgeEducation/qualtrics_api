require 'spec_helper'

describe QualtricsAPI::SurveyCollection do

  let(:connection) { double('connection') }

  subject { described_class.new connection: connection, scope_id: "fake_scopeId" }

  it "has a scope_id" do
    expect(subject.scope_id).to eq "fake_scopeId"
  end

  it "can assign scope_id" do
    expect(subject).to respond_to :scope_id=
  end

  it "takes a connection" do
    expect(subject.instance_variable_get(:@conn)).to eq connection
  end

  describe "#attributes" do
    it "returns only scope_id" do
      expect(subject.attributes.size).to eq 1
      expect(subject.attributes[:scope_id]).to eq "fake_scopeId"
    end
  end

end
