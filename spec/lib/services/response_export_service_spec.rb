require 'spec_helper'

describe QualtricsAPI::Services::ResponseExportService do
  describe "initialize" do
    let(:params) do
      {
        format: "file type",
        survey_id: "s_id",
        last_response_id: "l_id",
        start_date: "03/22/2015 06:11:11",
        end_date: "03/25/2015 06:00:00",
        limit: "1000",
        included_question_ids: "ids,ids",
        use_labels: true,
        decimal_separator: ",",
        seen_unanswered_recode: "something",
        use_local_time: true
      }
    end
    subject { described_class.new params }

    describe "assign options" do
      before do
        allow_any_instance_of(described_class).to receive(:start)
      end

      it "assigns passed options" do
        params.each do |key, value|
          expect(subject.send(key)).to eq value
        end
      end

      describe "defaults" do
        subject { described_class.new }

        it "has default @use_labels - false" do
          expect(subject.use_labels).to eq false
        end

        it "has default @use_local_time - false" do
          expect(subject.use_local_time).to eq false
        end

        it "has default @format - csv" do
          expect(subject.format).to eq 'csv'
        end

        it "has default @decimal_separator - ." do
          expect(subject.decimal_separator).to eq '.'
        end
      end
    end

    describe "#start" do
      it "calls url with export params" do
        expect(QualtricsAPI.connection)
          .to receive(:post)
          .with("responseexports", 
                "format" => "file type",
                "surveyId" => "s_id",
                "lastResponseId" => "l_id",
                "startDate" => "03/22/2015 06:11:11",
                "endDate" => "03/25/2015 06:00:00",
                "limit" => "1000",
                "includedQuestionIds" => "ids,ids",
                "useLabels" => true,
                "decimalSeparator" => ",",
                "seenUnansweredRecode" => "something",
                "useLocalTime" => true).and_return(double('resBody', body: { "result" => { "exportStatus" => "some/url" } }))
        subject.start
      end

      it "assigns and returns a ResponseExport with the id in the url" do
        allow(QualtricsAPI.connection).to receive(:post)
          .and_return(double('resBody', body: { "result" => { "id" => "exportId" } }))
        sut = subject.start
        expect(sut).to be_a QualtricsAPI::ResponseExport
        expect(subject.result).to eq sut
      end
    end
  end

  describe "#integration" do
    subject do
      VCR.use_cassette("response_export_start_success") do
        QualtricsAPI.surveys["SV_bpCTGQvjOqgd4RD"].export_responses.start
      end
    end

    it "assigns @result with the export id" do
      expect(subject).to_not be_nil
      expect(subject).to be_a QualtricsAPI::ResponseExport
      expect(subject.id).to eq "ES_to9jgploprbdnvi7uir84vq59l"
    end
  end
end
