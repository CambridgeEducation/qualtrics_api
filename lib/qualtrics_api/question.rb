module QualtricsAPI
  class Question < BaseModel
    values do
      attribute :question_text, String
      attribute :data_export_tag, String
      attribute :question_type, String
      attribute :selector, String
      attribute :sub_selector, String
      attribute :configuration, Hash
      attribute :question_description, String
      attribute :choices, Hash
      attribute :choice_order, Array
      attribute :validation, Hash
      attribute :language, Array
      attribute :next_choice_id, Integer
      attribute :next_answer_id, Integer
      attribute :question_id, String
      attribute :question_text_unsafe, String
    end

    private

    def attributes_mappings
      {
        :question_text => "QuestionText",
        :data_export_tag => "DataExportTag",
        :question_type => "QuestionType",
        :selector => "Selector",
        :sub_selector => "SubSelector",
        :configuration => "Configuration",
        :question_description => "QuestionDescription",
        :choices => "Choices",
        :choice_order => "ChoiceOrder",
        :validation => "Validation",
        :language => "Language",
        :next_choice_id => "NextChoiceId",
        :next_answer_id => "NextAnswerId",
        :question_id => "QuestionID",
        :question_text_unsafe => "QuestionText_Unsafe"
      }
    end
  end
end
