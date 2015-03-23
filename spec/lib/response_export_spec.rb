require 'spec_helper'

describe QualtricsAPI::ResponseExport do

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
        subject
      end
    end
  end

  describe "#integration" do
    let(:client) { QualtricsAPI.new TEST_API_TOKEN }

    subject do
      VCR.use_cassette("response_export_start_success") do
        client.surveys["SV_djzgZ6eJXqnIUyF"].export_responses
      end
    end

    it "assigns @status_url" do
      expect(subject.instance_variable_get(:@status_url)).to_not be_nil
    end

    it "resets file_url" do
      expect(subject.instance_variable_get(:@file_url)).to be_nil
    end

    it "sets export_progress to 0" do
      expect(subject.instance_variable_get(:@export_progress)).to eq 0
    end

    describe "#completed?" do
      it "is true when @completed is true" do
        subject.instance_variable_set(:@completed, true)
        expect(subject.completed?).to eq true
      end

      it "is false when @completed is false" do
        subject.instance_variable_set(:@completed, false)
        expect(subject.completed?).to eq false
      end
    end

    describe "#status" do
      describe "when completed" do
        it "returns the progress string without calling update" do
          subject.instance_variable_set(:@completed, true)
          subject.instance_variable_set(:@export_progress, 100)
          expect(subject).to_not receive(:update)
          expect(subject.status).to eq "100%"
        end
      end

      describe "when not completed" do
        it "calls update then prints progress" do
          subject.instance_variable_set(:@export_progress, 10)
          expect(subject).to receive(:update)
          expect(subject.status).to eq "10%"
        end
      end
    end

    describe "#percent_completed" do
      describe "when completed" do
        it "returns the progress number without calling update" do
          subject.instance_variable_set(:@completed, true)
          subject.instance_variable_set(:@export_progress, 100)
          expect(subject).to_not receive(:update)
          expect(subject.percent_completed).to eq 100
        end
      end

      describe "when not completed" do
        it "calls update then prints progress" do
          subject.instance_variable_set(:@export_progress, 10)
          expect(subject).to receive(:update)
          expect(subject.percent_completed).to eq 10
        end
      end
    end

    describe "#file_url" do
      describe "when completed" do
        it "returns the progress number without calling update" do
          subject.instance_variable_set(:@completed, true)
          subject.instance_variable_set(:@file_url, "some_url")
          expect(subject).to_not receive(:update)
          expect(subject.file_url).to eq "some_url"
        end
      end

      describe "when not completed" do
        it "calls update then prints progress" do
          subject.instance_variable_set(:@export_progress, 10)
          expect(subject).to receive(:update)
          expect(subject.file_url).to be_nil
        end
      end
    end

    describe "#update" do
      it "updates the status of the export then returns itself" do
        VCR.use_cassette("response_export_update_success") do
          expect(subject.completed?).to be_falsy
          expect(subject.instance_variable_get(:@file_url)).to be_nil
          expect(subject.instance_variable_get(:@export_progress)).to eq 0

          result = subject.update

          expect(subject.completed?).to be_truthy
          expect(subject.instance_variable_get(:@file_url)).to_not be_nil
          expect(subject.instance_variable_get(:@export_progress)).to eq 100.0

          expect(result).to eq subject
        end
      end
    end
  end

end
