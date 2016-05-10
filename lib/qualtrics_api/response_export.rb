module QualtricsAPI
  class ResponseExport < BaseModel
    values do
      attribute :id, String
    end

    def update_status
      res = QualtricsAPI.connection(self).get('responseexports/' + id).body["result"]
      @export_progress = res["percentComplete"]
      @file_url = res["file"]
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

    def open(&block)
      Kernel.open(@file_url, QualtricsAPI.connection(self).headers, &block)
    end
  end
end
