require 'logger'

module QualtricsAPI
  class RequestErrorHandler < Faraday::Response::Middleware
    def on_complete(env)
      raise_http_errors(env[:status], env[:body])
      show_notices(env[:body])
    end

    private

    def raise_http_errors(code, body)
      case code
      when 404
        raise NotFoundError, "Not Found"
      when 400
        raise BadRequestError, error_message(JSON.parse(body))
      when 401
        raise UnauthorizedError, error_message(JSON.parse(body))
      when 500
        raise InternalServerError, error_message(JSON.parse(body))
      end
    end

    def show_notices(body)
      response = JSON.parse(body)
      notice = response["meta"]["notice"]
      if notice && notice.size > 0
        STDERR.puts notice
      end
    end

    def error_message(response)
      meta = response["meta"]
      err = meta["error"] || {}
      ["[",
      meta["status"] || meta["httpStatus"],
      " - ",
      err["qualtricsErrorCode"] || err["internalErrorCode"] || err["errorCode"],
       "] ",
       err["errorMessage"]
      ].join
    end
  end

  class NotYetFetchedError < StandardError; end
  class NotFoundError < StandardError; end
  class BadRequestError < StandardError; end
  class UnauthorizedError < StandardError; end
  class InternalServerError < StandardError; end
  class NotSupported < StandardError; end
end
