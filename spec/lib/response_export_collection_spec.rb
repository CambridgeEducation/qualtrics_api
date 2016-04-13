require 'spec_helper'

describe QualtricsAPI::ResponseExportCollection do
  it "has no @page when initialized" do
    expect(subject.page).to eq []
  end

  describe "#find, #[]" do
    let(:export_1) { QualtricsAPI::ResponseExport.new(:id => "export1") }
    let(:export_2) { QualtricsAPI::ResponseExport.new(:id => "export2") }

    it "finds the export by id" do
      subject.instance_variable_set :@page, [export_1, export_2]
      expect(subject.find("export1")).to eq export_1
      expect(subject["export2"]).to eq export_2
    end

    it "returns a new survey with the id" do
      sut = subject["eee 3"]
      expect(sut).to be_a QualtricsAPI::ResponseExport
      expect(sut.id).to eq "eee 3"
    end
  end

  describe 'equality' do
    subject { described_class.new(page: [QualtricsAPI::ResponseExport.new(:id => "export1"), QualtricsAPI::ResponseExport.new(:id => "export2")]) }
    context 'when same' do
      it 'returns true' do
        expect(subject).to eq(described_class.new(page: subject.page))
      end
    end
  
    context 'when different' do
      it 'returns false' do
        expect(subject).not_to eq(described_class.new)
      end
    end
  end
end
