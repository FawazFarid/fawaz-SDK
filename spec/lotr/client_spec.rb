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
      resp = @client.movies
      expect(resp["docs"]).to be_kind_of Array
      expect(resp["docs"].first["name"]).to be_kind_of String
    end

    it "returns movies with a limit" do
      resp = @client.movies(limit: 1)
      expect(resp["docs"].length).to eq 1
    end

    it "returns movies with a sort" do
      resp = @client.movies(sort: "name", order: "asc")
      expect(resp["docs"].first["name"]).to eq "The Battle of the Five Armies"
    end
  end

  describe ".movie", :vcr do
    it "returns a movie" do
      resp = @client.movie(movie_id)
      expect(resp["docs"]).to be_kind_of Array
      expect(resp["docs"].first["name"]).to be_kind_of String
    end
  end

  describe ".quotes_for_movie", :vcr do
    it "returns quotes for a movie" do
      resp = @client.quotes_for_movie(movie_id)
      expect(resp["docs"]).to be_kind_of Array
      expect(resp["docs"].first["dialog"]).to be_kind_of String
    end

    it "returns quotes for a movie with a limit" do
      resp = @client.quotes_for_movie(movie_id, limit: 1)
      expect(resp["docs"].length).to eq 1
    end

    it "returns quotes for a movie with a sort" do
      resp = @client.quotes_for_movie(movie_id, sort: "dialog", order: "desc")
      expect(resp["docs"].first["dialog"]).to eq "hmmmhmmm"
    end
  end
end
