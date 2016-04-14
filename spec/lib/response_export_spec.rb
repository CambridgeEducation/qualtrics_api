require 'spec_helper'

describe QualtricsAPI::ResponseExport do
  subject { described_class.new id: "someId" }

  describe "#completed?" do
    it "is true when @completed is true" do
      subject.instance_variable_set(:@completed, true)
      expect(subject.completed?).to eq true
    end

    it "is false when @completed is false" do
      subject.instance_variable_set(:@completed, false)
      expect(subject.completed?).to eq false
    end
  end

  describe "#status" do
    describe "when completed" do
      it "returns the progress string without calling update" do
        subject.instance_variable_set(:@completed, true)
        subject.instance_variable_set(:@export_progress, 100)
        expect(subject).to_not receive(:update_status)
        expect(subject.status).to eq "100%"
      end
    end

    describe "when not completed" do
      it "calls update then prints progress" do
        subject.instance_variable_set(:@export_progress, 10)
        expect(subject).to receive(:update_status)
        expect(subject.status).to eq "10%"
      end
    end
  end

  describe "#percent_completed" do
    describe "when completed" do
      it "returns the progress number without calling update" do
        subject.instance_variable_set(:@completed, true)
        subject.instance_variable_set(:@export_progress, 100)
        expect(subject).to_not receive(:update_status)
        expect(subject.percent_completed).to eq 100
      end
    end

    describe "when not completed" do
      it "calls update then prints progress" do
        subject.instance_variable_set(:@export_progress, 10)
        expect(subject).to receive(:update_status)
        expect(subject.percent_completed).to eq 10
      end
    end
  end

  describe "#file_url" do
    describe "when completed" do
      it "returns the progress number without calling update" do
        subject.instance_variable_set(:@completed, true)
        subject.instance_variable_set(:@file_url, "some_url")
        expect(subject).to_not receive(:update_status)
        expect(subject.file_url).to eq "some_url"
      end
    end

    describe "when not completed" do
      it "calls update then prints progress" do
        subject.instance_variable_set(:@export_progress, 10)
        expect(subject).to receive(:update_status)
        expect(subject.file_url).to be_nil
      end
    end
  end

  describe "#update_status" do
    it "updates the status of the export then returns itself" do
      VCR.use_cassette("response_export_update_success") do
        subject = described_class.new id: "ES_abcd"

        result = subject.update_status

        expect(subject.completed?).to be_truthy
        expect(subject.instance_variable_get(:@file_url)).to_not be_nil
        expect(subject.instance_variable_get(:@export_progress)).to eq 100.0

        expect(result).to eq subject
      end
    end
  end

  describe 'equality' do
    context 'when same' do
      it 'returns true' do
        expect(subject).to eq(described_class.new(subject.attributes))
      end
    end
  
    context 'when different' do
      it 'returns false' do
        expect(subject).not_to eq(described_class.new)
      end
    end
  end
end
