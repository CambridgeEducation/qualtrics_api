module QualtricsAPI
  class ResponseExport
    include Virtus.value_object

    attribute :conn
    attribute :id, String

    def initialize(options = {})
      @conn = options[:connection]
      @id = options[:id]
    end

    def update_status
      res = @conn.get('surveys/responseExports/' + @id).body["result"]
      @export_progress = res["percentComplete"]
      @file_url = res["fileUrl"]
      @completed = true if @export_progress == 100.0
      self
    end

    def status
      update_status unless completed?
      "#{@export_progress}%"
    end

    def percent_completed
      update_status unless completed?
      @export_progress
    end

    def completed?
      @completed == true
    end

    def file_url
      update_status unless completed?
      @file_url
    end
  end
end
