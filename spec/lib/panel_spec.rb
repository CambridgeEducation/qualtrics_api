require 'spec_helper'

describe QualtricsAPI::Panel do
  let(:qualtrics_response) do
    {
      "panelid" => "ML_bseUhQDwAJolD1j",
      "name" => "Master Panel",
      "libraryId" => "GR_2aaKA1aGidXQtOA",
      "category" => "Unassigned"
    }
  end

  let(:connection) { double('connection', get: {}) }

  subject { described_class.new qualtrics_response.merge(connection: connection) }

  it "has an panelId" do
    expect(subject.id).to eq qualtrics_response["panelId"]
  end

  it "has a name" do
    expect(subject.name).to eq qualtrics_response["name"]
  end

  it "has an libraryId" do
    expect(subject.library_id).to eq qualtrics_response["libraryId"]
  end

  it "has category" do
    expect(subject.category).to eq qualtrics_response["category"]
  end

  it "has a connection" do
    expect(subject.connection).to eq connection
  end
end
