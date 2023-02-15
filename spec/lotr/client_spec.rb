# frozen_string_literal: true

require "spec_helper"

RSpec.describe Lotr::Client do
  before do
    @client = Lotr::Client.new(api_key: test_lotr_api_key)
  end

  describe ".movies", :vcr do
    it "returns all movies" do
      resp = @client.movies
      expect(resp["docs"]).to be_kind_of Array
      expect(resp["docs"].first["name"]).to be_kind_of String
    end
  end

  describe ".movie", :vcr do
    it "returns a movie" do
      resp = @client.movie("5cd95395de30eff6ebccde5c")
      expect(resp["docs"]).to be_kind_of Array
      expect(resp["docs"].first["name"]).to be_kind_of String
    end
  end
end
