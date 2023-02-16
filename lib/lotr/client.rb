require "httparty"
require "lotr/response"

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
      handle_response(resp, multiple_items: true)
    end
    alias get_movies movies

    def movie(movie_id)
      resp = self.class.get("/movie/#{movie_id}", headers: @headers)
      handle_response(resp)
    end
    alias get_movie movie

    def quotes_for_movie(movie_id, options = {})
      resp = self.class.get("/movie/#{movie_id}/quote", headers: @headers, query: parse_query_params(options))
      handle_response(resp, multiple_items: true)
    end
    alias get_quotes_for_movie quotes_for_movie

    private

    def handle_response(resp, multiple_items: false)
      handle_error_response(resp) unless resp.success?

      docs = resp["docs"]
      return Lotr::Response.parse_to_object!(docs.first) unless multiple_items

      docs.map { |item| Lotr::Response.parse_to_object!(item) }
    end

    def handle_error_response(resp)
      error = Lotr::Error.from_response(resp)
      raise error
    end

    def parse_query_params(options)
      # merge the sort and order params into one e.g sort=name:asc
      options[:sort] = "#{options[:sort]}:#{options[:order]}" if options[:order]
      options.delete(:order)
      options
    end
  end
end
