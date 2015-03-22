require 'spec_helper'

describe QualtricsAPI::ResponseExport do

  let(:params) do
    {
      survey_id: "s_id",
      response_set_id: "r_set_id",
      file_type: "file type",
      last_response_id: "l_id",
      start_date: "03/22/2015 06:11:11",
      end_date: "03/25/2015 06:00:00",
      limit: "1000",
      included_question_ids: "ids,ids",
      max_rows: "1000",
      use_labels: true,
      decimal_format: ",",
      seen_unanswered_recode: "something",
      use_local_time: true,
      spss_string_length: "15",
    }
  end
  let(:connection) { double("connection") }

  subject { described_class.new params.merge(connection: connection)}

  it "assigns passed options" do
    params.each do |key, value|
      expect(subject.send(key)).to eq value
    end
  end

  it "assigns connection" do
    expect(subject.instance_variable_get(:@conn)).to eq connection
  end

  describe "defaults" do
    subject { described_class.new connection: connection }

    it "has default @use_labels - false" do
      expect(subject.use_labels).to eq false
    end

    it "has default @use_local_time - false" do
      expect(subject.use_local_time).to eq false
    end

    it "has default @file_type - csv" do
      expect(subject.file_type).to eq 'CSV'
    end

    it "has default @decimal_format - ." do
      expect(subject.decimal_format).to eq '.'
    end
  end

end
