require 'spec_helper'

describe QualtricsAPI::PanelMember do
  let(:panel_member) do
    {
      "panelMemberId" => "ML_abcdefg",
      "firstName" => "Thom",
      "lastName" => "Yorke",
      "email" => "thom@radiohead.com",
      "externalDataReference" => "1234",
      "embeddedData" => { "a" => "b", "b" => "c" }
    }
  end

  let(:connection) { double('connection', get: {}) }
  subject { described_class.new panel_member.merge(connection: connection) }

  it "has a panel member id" do
    expect(subject.id).to eq(panel_member["panelMemberId"])
  end

  it "has a first name" do
    expect(subject.first_name).to eq(panel_member["firstName"])
  end

  it "has a last name" do
    expect(subject.last_name).to eq(panel_member["lastName"])
  end

  it "has an email" do
    expect(subject.email).to eq(panel_member["email"])
  end

  it "has external data reference" do
    expect(subject.external_data_reference).to eq(panel_member["externalDataReference"])
  end

  it "has embedded data" do
    expect(subject.embeded_data).to eq(panel_member["embeddedData"])
  end
end
