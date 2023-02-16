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

    def movies(options = {})
      resp = self.class.get("/movie", headers: @headers, query: parse_query_params(options))
      handle_response(resp)
    end

    def movie(movie_id)
      resp = self.class.get("/movie/#{movie_id}", headers: @headers)
      handle_response(resp)
    end

    def quotes_for_movie(movie_id, options = {})
      resp = self.class.get("/movie/#{movie_id}/quote", headers: @headers, query: parse_query_params(options))
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

    def parse_query_params(options)
      # merge the sort and order params into one e.g sort=name:asc
      options[:sort] = "#{options[:sort]}:#{options[:order]}" if options[:order]
      options.delete(:order)
      options
    end
  end
end
