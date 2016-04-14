module QualtricsAPI
  module Services
    class ResponseExportService < QualtricsAPI::BaseModel
      values do
        attribute :format, String, :default => 'csv'
        attribute :survey_id, String
        attribute :last_response_id, String
        attribute :start_date, String
        attribute :end_date, String
        attribute :limit, String
        attribute :included_question_ids, String
        attribute :use_labels, Boolean, :default => false
        attribute :decimal_separator, String, :default => '.'
        attribute :seen_unanswered_recode, String
        attribute :use_local_time, Boolean, :default => false

        attribute :id, String
      end
      
      attr_reader :result

      def start
        response = QualtricsAPI.connection(self).post("responseexports", export_params)
        export_id = response.body["result"]["id"]
        @result = ResponseExport.new(id: export_id)
      end

      def export_configurations
        {
          format: format,
          survey_id: survey_id,
          last_response_id: last_response_id,
          start_date: start_date,
          end_date: end_date,
          limit: limit,
          included_question_ids: included_question_ids,
          use_labels: use_labels,
          decimal_separator: decimal_separator,
          seen_unanswered_recode: seen_unanswered_recode,
          use_local_time: use_local_time
        }
      end

      private

      def param_mappings
        {
          format: "format",
          survey_id: "surveyId",
          last_response_id: "lastResponseId",
          start_date: "startDate",
          end_date: "endDate",
          limit: "limit",
          included_question_ids: "includedQuestionIds",
          use_labels: "useLabels",
          decimal_separator: "decimalSeparator",
          seen_unanswered_recode: "seenUnansweredRecode",
          use_local_time: "useLocalTime"
        }
      end

      def export_params
        export_configurations.map do |config_key, value|
          [param_mappings[config_key], value] unless value.nil? || value.to_s.empty?
        end.compact.to_h
      end
    end
  end
end
