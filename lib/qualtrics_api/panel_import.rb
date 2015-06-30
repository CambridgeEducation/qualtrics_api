module QualtricsAPI
  class PanelImport
    include Virtus.value_object

    attribute :connection
    attribute :id, String
    attribute :panel_id, String

    def update_status
      res = connection.get("panels/#{panel_id}/members/panelImports/#{id}").body["result"]
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
