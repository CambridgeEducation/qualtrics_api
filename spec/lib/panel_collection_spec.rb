require 'spec_helper'

describe QualtricsAPI::PanelCollection do
  it "has no @page when initialized" do
    expect(subject.page).to eq []
  end

  describe "#find, #[]" do
    let(:panel_1) { QualtricsAPI::Panel.new "panelId" => "p1" }
    let(:panel_2) { QualtricsAPI::Panel.new "panelId" => "p2" }

    it "finds the panel by id" do
      subject.instance_variable_set :@all, [panel_1, panel_2]
      expect(subject.find("p1")).to eq panel_1
      expect(subject["p2"]).to eq panel_2
    end

    it "returns a new panel with the id" do
      new_panel = subject["p3"]
      expect(new_panel).to be_a QualtricsAPI::Panel
      expect(new_panel.id).to eq "p3"
    end
  end

  describe "integration" do
    describe "#fetch" do
      describe "when success" do
        before do
          expect(subject.page.size).to eq 0
        end

        let!(:result) do
          VCR.use_cassette("panel_collection_fetch_success") do
            subject.fetch
          end
        end

        it "populates the collection" do
          expect(subject.page.size).to eq 1
          expect(subject.first).to be_a QualtricsAPI::Panel
        end

        it "returns itself" do
          expect(result).to eq subject
        end
      end

      describe "when failed" do
        it "raises error and does not reset panels" do
          subject.instance_variable_set :@page, [QualtricsAPI::Panel.new({})]
          expect {
            VCR.use_cassette("panel_collection_fetch_fail") do
              subject.fetch rescue nil
            end
          }.not_to change { subject.page }
        end
      end
    end
  end

  describe 'equality' do
    subject { described_class.new(page: [QualtricsAPI::Panel.new("panelId" => "p1"), QualtricsAPI::Panel.new("panelId" => "p2")]) }
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
