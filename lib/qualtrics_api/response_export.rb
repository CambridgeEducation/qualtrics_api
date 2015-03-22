module QualtricsAPI

  class ResponseExport

    attr_accessor :survey_id,
                  :response_set_id,
                  :file_type,
                  :last_response_id,
                  :start_date,
                  :end_date,
                  :limit,
                  :included_question_ids,
                  :max_rows,
                  :use_labels,
                  :decimal_format,
                  :seen_unanswered_recode,
                  :use_local_time,
                  :spss_string_length

    def initialize(options)
      @conn = options[:connection]
      @survey_id = options[:survey_id]
      @response_set_id = options[:response_set_id]
      @file_type = options[:file_type] || 'CSV'
      @last_response_id = options[:last_response_id]
      @start_date = options[:start_date]
      @end_date = options[:end_date]
      @limit = options[:limit]
      @included_question_ids = options[:included_question_ids]
      @max_rows = options[:max_rows]
      @use_labels = options.has_key?(:use_labels) ? options[:use_labels] : false
      @decimal_format = options[:decimal_format] || '.'
      @seen_unanswered_recode = options[:seen_unanswered_recode]
      @use_local_time = options.has_key?(:use_local_time) ? options[:use_local_time] : false
      @spss_string_length = options[:spss_string_length]
    end

    def export_configurations
      {
        response_set_id: @response_set_id,
        file_type: @file_type,
        last_response_id: @last_response_id,
        start_date: @start_date,
        end_date: @end_date,
        limit: @limit,
        included_question_ids: @included_question_ids,
        max_rows: @max_rows,
        use_labels: @use_labels,
        decimal_format: @decimal_format,
        seen_unanswered_recode: @seen_unanswered_recode,
        use_local_time: @use_local_time,
        spss_string_length: @spss_string_length
      }
    end

  end

end
