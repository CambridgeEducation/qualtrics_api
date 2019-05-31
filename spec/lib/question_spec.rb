require 'spec_helper'

describe QualtricsAPI::Question do
  let(:qualtrics_response) do
    {
      "QuestionText" => "Who is your favorite writer?",
      "DataExportTag" => "Q1",
      "QuestionType" => "MC",
      "Selector" => "SAVR",
      "SubSelector" => "TX",
      "Configuration" => {
        "QuestionDescriptionOption" => "UseText"
      },
      "QuestionDescription" => "Who is your favorite writer?",
      "Choices" => {
        "1" => {
          "Display" => "Thomas Mann"
        },
        "2" => {
          "Display" => "Albert Camus"
        },
        "3" => {
          "Display" => "Anton Chekov"
        }
      },
      "ChoiceOrder" => [
        1,
        2,
        3
      ],
      "Validation" => {
        "Settings" => {
          "ForceResponse" => "OFF",
          "ForceResponseType" => "ON",
          "Type" => "None"
        }
      },
      "Language" => [],
      "NextChoiceId" => 4,
      "NextAnswerId" => 1,
      "QuestionID" => "QID1",
      "QuestionText_Unsafe" => "Who is your favorite writer?"
    }
  end

  subject { described_class.new qualtrics_response }

  it "has question text" do
    expect(subject.question_text).to eq qualtrics_response["QuestionText"]
  end

  it "has a data export tag" do
    expect(subject.data_export_tag).to eq qualtrics_response["DataExportTag"]
  end

  it "has a question type" do
    expect(subject.question_type).to eq qualtrics_response["QuestionType"]
  end

  it "has a selector" do
    expect(subject.selector).to eq qualtrics_response["Selector"]
  end

  it "has a sub selector" do
    expect(subject.sub_selector).to eq qualtrics_response["SubSelector"]
  end

  it "has a configuration" do
    expect(subject.configuration).to eq qualtrics_response["Configuration"]
  end

  it "has a question description" do
    expect(subject.question_description).to eq qualtrics_response["QuestionDescription"]
  end

  it "has choices" do
    expect(subject.choices).to eq qualtrics_response["Choices"]
  end

  it "has a choice order" do
    expect(subject.choice_order).to eq qualtrics_response["ChoiceOrder"]
  end

  it "has validation" do
    expect(subject.validation).to eq qualtrics_response["Validation"]
  end

  it "has a language" do
    expect(subject.language).to eq qualtrics_response["Language"]
  end

  it "has a next choice id" do
    expect(subject.next_choice_id).to eq qualtrics_response["NextChoiceId"]
  end

  it "has a next answer id" do
    expect(subject.next_answer_id).to eq qualtrics_response["NextAnswerId"]
  end

  it "has a question id" do
    expect(subject.question_id).to eq qualtrics_response["QuestionID"]
  end

  it "has question text (unsafe)" do
    expect(subject.question_text_unsafe).to eq qualtrics_response["QuestionText_Unsafe"]
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
