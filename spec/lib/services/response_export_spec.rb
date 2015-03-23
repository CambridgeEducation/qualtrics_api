require 'spec_helper'

describe QualtricsAPI::ResponseExportService do

  describe "initialize" do
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

    describe "assgin options" do
      before do
        allow_any_instance_of(described_class).to receive(:start)
      end

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

    describe "#start" do
      it "calls url with export params" do
        expect(connection).to receive(:get).with("surveys/s_id/responseExports", {
          "responseSetId" => "r_set_id",
          "fileType" => "file type",
          "lastResponseId" => "l_id",
          "startDate" => "03/22/2015 06:11:11",
          "endDate" => "03/25/2015 06:00:00",
          "limit" => "1000",
          "includedQuestionIds" => "ids,ids",
          "maxRows" => "1000",
          "useLabels" => true,
          "decimalFormat" => ",",
          "seenUnansweredRecode" => "something",
          "useLocalTime" => true,
          "spssStringLength" => "15"
        }).and_return(double('resBody', body: {"result" => { "exportStatus" => "some/url" }}))
        subject.start
      end

      it "assigns and returns a ResponseExport with the id in the url" do
        allow(connection).to receive(:get)
          .and_return(double('resBody', body: {"result" => { "exportStatus" => "some/url/exportId" }}))
        sut = subject.start
        expect(sut).to be_a QualtricsAPI::ResponseExport
        expect(subject.result).to eq sut
      end
    end
  end

  describe "#integration" do
    let(:client) { QualtricsAPI.new TEST_API_TOKEN }

    subject do
      VCR.use_cassette("response_export_start_success") do
        client.surveys["SV_djzgZ6eJXqnIUyF"].export_responses.start
      end
    end

    it "assigns @result with the export id" do
      expect(subject).to_not be_nil
      expect(subject).to be_a QualtricsAPI::ResponseExport
      expect(subject.id).to eq "ES_cwLvnQHobKfV9t3"
    end
  end

end
