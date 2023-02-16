# frozen_string_literal: true

module Lotr
  class Error < StandardError
    # Returns the appropriate Lotr::Error subclass based
    # on status and response message
    #
    # @param [Hash] response HTTP response
    # @return [Lotr::Error]
    def self.from_response(response)
      status = response.code
      klass = case status
              when 400      then Lotr::BadRequest
              when 401      then Lotr::Unauthorized
              when 403      then Lotr::Forbidden
              when 404      then Lotr::NotFound
              when 422      then Lotr::UnprocessableEntity
              when 429      then Lotr::TooManyRequests
              when 400..499 then Lotr::ClientError
              when 500      then Lotr::InternalServerError
              when 501      then Lotr::NotImplemented
              when 502      then Lotr::BadGateway
              when 503      then Lotr::ServiceUnavailable
              when 500..599 then Lotr::ServerError
              end
      klass.new(response)
    end
  end

  # Raised on errors in the 400-499 range
  class ClientError < Error; end

  # Raised when The One API returns a 400 HTTP status code
  class BadRequest < ClientError; end

  # Raised when The One API returns a 401 HTTP status code
  class Unauthorized < ClientError; end

  # Raised when The One API returns a 403 HTTP status code
  class Forbidden < ClientError; end

  # Raised when The One API returns a 404 HTTP status code
  class NotFound < ClientError; end

  # Raised when The One API returns a 422 HTTP status code
  class UnprocessableEntity < ClientError; end

  # Raised when The One API returns a 429 HTTP status code
  class TooManyRequests < ClientError; end

  # Raised on errors in the 500-599 range
  class ServerError < Error; end

  # Raised when The One API returns a 500 HTTP status code
  class InternalServerError < ServerError; end

  # Raised when The One API returns a 501 HTTP status code
  class NotImplemented < ServerError; end

  # Raised when The One API returns a 502 HTTP status code
  class BadGateway < ServerError; end

  # Raised when The One API returns a 503 HTTP status code
  class ServiceUnavailable < ServerError; end

end
