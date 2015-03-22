module QualtricsAPI

  class RequestErrorHandler < Faraday::Response::Middleware

    def on_complete(env)
      case env[:status]
      when 404
        raise StandardError, "Not Found"
      when 400
        raise StandardError, error_message(response)
      end
    end

    private

    def error_message(response)
      meta = response["meta"]
      [ "[",
        meta["status"], " - ",
        meta["qualtricsErrorCode"],
        "] ",
        meta["errorMessage"]
      ].join
    end

  end

end
