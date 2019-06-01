require 'spec_helper'

describe QualtricsAPI::QuestionCollection do
  describe "integration" do
    subject { described_class.new }
    let(:survey_id) { 'SV_a2AcbPZz1DehlOd' }
    let(:missing_survey_id) { 'SV_a2AcbPZz1Dxxxx' }
    let(:question_id) { 'QID1' }
    let(:missing_question_id) { 'QID1xxxx' }
    let(:question_attr_keys) do
      %i[
        question_text
        data_export_tag
        question_type
        selector
        sub_selector
        configuration
        question_description
        choices
        choice_order
        validation
        language
        next_choice_id
        next_answer_id
        question_id
        question_text_unsafe
      ]
    end

    describe "#find" do
      context 'when exists' do
        let!(:result) do
          VCR.use_cassette("question_find") do
            subject.find(survey_id, question_id)
          end
        end

        it 'populates the result' do
          expect(result.attributes.keys).to match_array(question_attr_keys)
        end
      end

      context 'when does not exist' do
        let!(:result) do
          VCR.use_cassette("question_find_fail") do
            subject.find(missing_survey_id, missing_question_id)
          end
        end

        it 'raises error', skip: 'API Bug' do
          # TODO: API returns 403 in this case. 404 seems more appropriate.
          # expect { result }.to raise_error(QualtricsAPI::NotFoundError)
        end
      end
    end

    describe "#fetch" do
      describe "when success" do
        let!(:result) do
          VCR.use_cassette("question_collection_fetch_success") do
            subject.each_page(survey_id) do |page|
              return page
            end
          end
        end

        it "populates the collection" do
          expect(result.first).to be_a QualtricsAPI::Question
        end
      end

      describe "when failed" do
        let!(:result) do
          VCR.use_cassette("question_collection_fetch_fail") do
            subject.each_page(missing_survey_id)
          end
        end

        it "raises error", skip: 'API Bug' do
          # TODO: API returns 403 in this case. 404 seems more appropriate.
          # expect { result }.to raise_error(QualtricsAPI::NotFoundError)
        end
      end
    end
  end
end
