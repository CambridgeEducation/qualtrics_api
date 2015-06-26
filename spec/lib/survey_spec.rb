require 'spec_helper'

describe QualtricsAPI::Survey do
  let(:qualtrics_response) do
    {
      "id" => "SV_djzgZ6eJXqnIUyF",
      "name" => "test_survey",
      "ownerId" => "UR_3fnAz35QCGlr725",
      "lastModified" => "2015-03-20 12:56:33",
      "status" => "Inactive",
      "SurveyCreationDate" => "2015-03-20 12:56:33"
    }
  end

  let(:connection) { double('connection', get: {}) }

  subject { described_class.new qualtrics_response.merge(connection: connection) }

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

  it "has created_at" do
    expect(subject.created_at).to eq qualtrics_response["SurveyCreationDate"]
  end

  it "has status" do
    expect(subject.status).to eq qualtrics_response["status"]
  end

  it "has a connection" do
    expect(subject.connection).to eq connection
  end

  describe "export_responses" do
    let(:options) do
      {
        start_date: "01/01/2015 10:11:22"
      }
    end

    it "inits a ResponseExportService with options" do
      expect(QualtricsAPI::Services::ResponseExportService).to receive(:new).with(start_date: options[:start_date],
                                                                                  survey_id: subject.id,
                                                                                  connection: subject.connection)

      subject.export_responses(options)
    end
  end
end
