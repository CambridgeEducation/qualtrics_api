module QualtricsAPI
  class RequestErrorHandler < Faraday::Response::Middleware
    def on_complete(env)
      case env[:status]
      when 404
        raise NotFoundError, "Not Found"
      when 400
        raise BadRequestError, error_message(JSON.parse(env[:body]))
      when 401
        raise UnauthorizedError, error_message(JSON.parse(env[:body]))
      when 500
        raise InternalServerError, error_message(JSON.parse(env[:body]))
      end
    end

    private

    def error_message(response)
      meta = response["meta"]
      ["[",
       meta["status"], " - ",
       meta["qualtricsErrorCode"] || meta["internalErrorCode"],
       "] ",
       meta["errorMessage"]
      ].join
    end
  end

  class NotFoundError < StandardError; end
  class BadRequestError < StandardError; end
  class UnauthorizedError < StandardError; end
  class InternalServerError < StandardError; end
  class NotSupported < StandardError; end
end
