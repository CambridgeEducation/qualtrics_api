require 'spec_helper'

describe QualtricsAPI::PanelMember do
  let(:panel_member) do
    {
      "panelMemberId" => "ML_abcdefg",
      "firstName" => "Thom",
      "lastName" => "Yorke",
      "email" => "thom@radiohead.com",
      "language" => "EN",
      "unsubscribed" => 1,
      "externalReference" => "1234",
      "embeddedData" => { "a" => "b", "b" => "c" }
    }
  end

  subject { described_class.new panel_member }

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

  it "has language" do
    expect(subject.language).to eq(panel_member["language"])
  end

  it "has unsubscribed flag" do
    expect(subject.unsubscribed).to eq(panel_member["unsubscribed"])
  end

  it "has external data reference" do
    expect(subject.external_reference).to eq(panel_member["externalDataReference"])
  end

  it "has embedded data" do
    expect(subject.embeded_data).to eq(panel_member["embeddedData"])
  end

  context "#to_json" do
    let(:panel_member) do
      {
        "panelMemberId" => "ML_abcdefg",
        "firstName" => "Thom",
        "lastName" => "Yorke",
        "email" => "thom@radiohead.com",
        "language" => "EN",
        "unsubscribed" => 1,
        "externalDataReference" => "1234",
        "embeddedData" => { "a" => "b", "b" => "c" }
      }
    end

    let(:members) { [subject].to_json }

    it "serialize array of panel members" do
      expect(JSON.parse(members)).to eq(
        [{ "RecipientID" => "ML_abcdefg",
           "FirstName" => "Thom",
           "LastName" => "Yorke",
           "Email" => "thom@radiohead.com",
           "Language" => "EN",
           "Unsubscribed" => 1,
           "ExternalReference" => "1234",
           "EmbeddedData" => { "a" => "b", "b" => "c" } }])
    end
  end
end
