module QualtricsAPI
  class PanelImport < BaseModel
    values do
      attribute :id, String
      attribute :panel_id, String
    end

    def update_status
      res = QualtricsAPI.connection(self).get("mailinglists/#{panel_id}/contactimports/#{id}").body["result"]
      @import_progress = res["percentComplete"]
      @completed = true if @import_progress == 100.0
      self
    end

    def status
      update_status unless completed?
      "#{@import_progress}%"
    end

    def percent_completed
      update_status unless completed?
      @import_progress
    end

    def completed?
      @completed == true
    end
  end
end
