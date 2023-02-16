# frozen_string_literal: true

require "spec_helper"

RSpec.describe Lotr::Client do
  before do
    @client = Lotr::Client.new(api_key: test_lotr_api_key)
  end

  let(:movie_id) do
    "5cd95395de30eff6ebccde5c"
  end

  describe ".movies", :vcr do
    it "returns all movies" do
      movies = @client.movies
      expect(movies).to be_kind_of Array
      expect(movies.first.name).to eq "The Lord of the Rings Series"
    end

    it "works with the alias method" do
      movies = @client.get_movies
      expect(movies).to be_kind_of Array
    end

    it "returns movies with a limit" do
      movies = @client.movies(limit: 1)
      expect(movies.length).to eq 1
    end

    it "returns movies with a sort" do
      movies = @client.movies(sort: "name", order: "asc")
      expect(movies.first["name"]).to eq "The Battle of the Five Armies"
    end
  end

  describe ".movie", :vcr do
    it "returns a movie" do
      movie = @client.movie(movie_id)
      expect(movie.name).to eq "The Fellowship of the Ring"
    end

    it "works with the alias method" do
      movie = @client.get_movie(movie_id)
      expect(movie.name).to eq "The Fellowship of the Ring"
    end

    it "raises an error if the movie id does not exist" do
      stub_request(:get, "https://the-one-api.dev/v2/movie/non-3xist3nt-mov13").to_return(status: 404)
      expect { @client.movie("non-3xist3nt-mov13") }.to raise_error(Lotr::NotFound)
    end
  end

  describe ".quotes_for_movie", :vcr do
    it "returns quotes for a movie" do
      quotes = @client.quotes_for_movie(movie_id)
      expect(quotes).to be_kind_of Array
      expect(quotes.first["dialog"]).to eq "Who is she? This woman you sing of?"
    end

    it "works with the alias method" do
      quotes = @client.get_quotes_for_movie(movie_id)
      expect(quotes).to be_kind_of Array
    end

    it "returns quotes for a movie with a limit" do
      quotes = @client.quotes_for_movie(movie_id, limit: 1)
      expect(quotes.length).to eq 1
    end

    it "returns quotes for a movie with a sort" do
      quotes = @client.quotes_for_movie(movie_id, sort: "dialog", order: "desc")
      expect(quotes.first["dialog"]).to eq "hmmmhmmm"
    end

    it "raises an error if the movie id does not exist" do
      stub_request(:get, "https://the-one-api.dev/v2/movie/non-3xist3nt-mov13/quote").to_return(status: 404)
      expect { @client.quotes_for_movie("non-3xist3nt-mov13") }.to raise_error(Lotr::NotFound)
    end
  end
end
