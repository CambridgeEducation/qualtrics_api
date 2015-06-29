require 'spec_helper'

describe QualtricsAPI::PanelMemberCollection do
  let(:connection) { double('connection') }

  subject { described_class.new connection: connection }

  it "has no @all when initialized" do
    expect(subject.all).to eq []
  end

  it "takes a connection" do
    expect(subject.connection).to eq connection
  end

  describe "#find, #[]" do
    let(:panel_member_1) { QualtricsAPI::PanelMember.new("panelMemberId" => "p1") }
    let(:panel_member_2) { QualtricsAPI::PanelMember.new("panelMemberId" => "p2") }

    it "finds the panel member by id" do
      subject.instance_variable_set :@all, [panel_member_1, panel_member_2]
      expect(subject.find("p1")).to eq panel_member_1
      expect(subject["p2"]).to eq panel_member_2
    end

    it "returns a new panel with the id" do
      new_panel_member = subject["p3"]
      expect(new_panel_member).to be_a QualtricsAPI::PanelMember
      expect(new_panel_member.id).to eq "p3"
      expect(new_panel_member.connection).to eq connection
    end
  end

  describe "integration" do
    let(:client) { QualtricsAPI.new TEST_API_TOKEN }

    subject { described_class.new(connection: client.connection, id: 'ABCD') }

    describe "#fetch" do
      describe "when success" do
        before do
          expect(subject.size).to eq 0
        end

        let!(:result) do
          VCR.use_cassette("panel_member_collection_fetch_success") do
            subject.fetch
          end
        end

        it "populates the collection" do
          expect(subject.size).to eq 1
          expect(subject.first).to be_a QualtricsAPI::PanelMember
        end

        it "passes down the connection" do
          expect(subject.all.first.connection).to eq client.connection
        end

        it "returns itself" do
          expect(result).to eq subject
        end
      end

      describe "when failed" do
        it "resets panels" do
          subject.instance_variable_set :@all, [QualtricsAPI::PanelMember.new({})]
          expect do
            VCR.use_cassette("panel_member_collection_fetch_fail") do
              expect { subject.fetch }.to raise_error
            end
          end.to change { subject.all }.to([])
        end
      end
    end
  end
end
