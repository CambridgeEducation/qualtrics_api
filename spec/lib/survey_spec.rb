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

  it "has is_active" do
    expect(subject.is_active).to eq qualtrics_response["is_active"]
  end

  describe "export_responses" do
    let(:options) do
      {
        start_date: "01/01/2015 10:11:22"
      }
    end

    it "inits a ResponseExportService with options" do
      expect(QualtricsAPI::Services::ResponseExportService).to receive(:new).with(start_date: options[:start_date],
                                                                                  survey_id: subject.id).and_return(QualtricsAPI::Services::ResponseExportService.new)

      subject.export_responses(options)
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
