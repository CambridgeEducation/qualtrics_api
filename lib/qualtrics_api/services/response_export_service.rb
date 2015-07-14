module QualtricsAPI
  module Services
    class ResponseExportService
      include Virtus.value_object

      attribute :survey_id, String
      attribute :response_set_id, String
      attribute :file_type, String, :default => 'CSV'
      attribute :last_response_id, String
      attribute :start_date, String
      attribute :end_date, String
      attribute :limit, String
      attribute :included_question_ids, String
      attribute :max_rows, String
      attribute :use_labels, Boolean, :default => false
      attribute :decimal_format, String, :default => '.'
      attribute :seen_unanswered_recode, String
      attribute :use_local_time, Boolean, :default => false
      attribute :spss_string_length, String
      attribute :id, String
      
      attr_reader :result

      def start
        response = QualtricsAPI.connection.get("surveys/#{survey_id}/responseExports", export_params)
        export_id = response.body["result"]["exportStatus"].split('/').last
        @result = ResponseExport.new(id: export_id)
      end

      def export_configurations
        {
          response_set_id: response_set_id,
          file_type: file_type,
          last_response_id: last_response_id,
          start_date: start_date,
          end_date: end_date,
          limit: limit,
          included_question_ids: included_question_ids,
          max_rows: max_rows,
          use_labels: use_labels,
          decimal_format: decimal_format,
          seen_unanswered_recode: seen_unanswered_recode,
          use_local_time: use_local_time,
          spss_string_length: spss_string_length
        }
      end

      private

      def param_mappings
        {
          response_set_id: "responseSetId",
          file_type: "fileType",
          last_response_id: "lastResponseId",
          start_date: "startDate",
          end_date: "endDate",
          limit: "limit",
          included_question_ids: "includedQuestionIds",
          max_rows: "maxRows",
          use_labels: "useLabels",
          decimal_format: "decimalFormat",
          seen_unanswered_recode: "seenUnansweredRecode",
          use_local_time: "useLocalTime",
          spss_string_length: "spssStringLength"
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
