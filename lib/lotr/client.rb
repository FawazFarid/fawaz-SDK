require "httparty"

module Lotr
  # Client for the Lord of the Rings API
  class Client
    include HTTParty
    base_uri "https://the-one-api.dev/v2"

    def initialize(options = {})
      @headers = { "Authorization" => "Bearer #{options[:api_key]}" }
    end

    def version
      Lotr::VERSION
    end

    def movies
      resp = self.class.get("/movie", headers: @headers)
      handle_response(resp)
    end

    def movie(movie_id)
      resp = self.class.get("/movie/#{movie_id}", headers: @headers)
      handle_response(resp)
    end

    def quotes_for_movie(movie_id)
      resp = self.class.get("/movie/#{movie_id}/quote", headers: @headers)
      handle_response(resp)
    end

    private

    def handle_response(resp)
      handle_error_response(resp) unless resp.success?

      JSON.parse(resp.body)
    end

    def handle_error_response(resp)
      raise Lotr::Error, "Error: #{resp.code} #{resp.message}"
    end
  end
end
