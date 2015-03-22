require 'spec_helper'

describe QualtricsAPI::Survey do

  let(:qualtrics_response) do
    {
      "id" => "SV_djzgZ6eJXqnIUyF",
      "name" => "test_survey",
      "ownerId" => "UR_3fnAz35QCGlr725",
      "lastModified" => "2015-03-20 12:56:33",
      "status" => "Inactive"
    }
  end

  subject { described_class.new qualtrics_response }

  it "has an id" do
    expect(subject.id).to eq qualtrics_response["id"]
  end

  it "has a name" do
    expect(subject.name).to eq qualtrics_response["name"]
  end

  it "has an ownerId" do
    expect(subject.owner_id).to eq qualtrics_response["ownerId"]
  end

  it "has last_modified" do
    expect(subject.last_modified).to eq qualtrics_response["lastModified"]
  end

  it "has status" do
    expect(subject.status).to eq qualtrics_response["status"]
  end

end
