require 'spec_helper'

describe QualtricsAPI::ResponseExportCollection do
  let(:connection) { double('connection') }

  subject { described_class.new connection: connection }

  it "has no @all when initialized" do
    expect(subject.all).to eq []
  end

  it "takes a connection" do
    expect(subject.instance_variable_get(:@conn)).to eq connection
  end

  describe "#find, #[]" do
    let(:export_1) { QualtricsAPI::ResponseExport.new :id => "export1" }
    let(:export_2) { QualtricsAPI::ResponseExport.new :id => "export2" }

    it "finds the export by id" do
      subject.instance_variable_set :@all, [export_1, export_2]
      expect(subject.find("export1")).to eq export_1
      expect(subject["export2"]).to eq export_2
    end

    it "returns a new survey with the id" do
      sut = subject["eee 3"]
      expect(sut).to be_a QualtricsAPI::ResponseExport
      expect(sut.id).to eq "eee 3"
      expect(sut.instance_variable_get(:@conn)).to eq connection
    end
  end
end
