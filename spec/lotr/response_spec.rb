RSpec.describe Lotr::Response do
  let(:raw_response) do
    {
      "_id": "5cd95395de30eff6ebccde5c",
      "name": "The Fellowship of the Ring",
      "runtimeInMinutes": 178,
      "budgetInMillions": 93,
      "boxOfficeRevenueInMillions": 871.5,
      "academyAwardNominations": 13,
      "academyAwardWins": 4,
      "rottenTomatoesScore": 91
    }
  end

  describe ".parse_to_object!" do
    it "returns correct values" do
      response = Lotr::Response.parse_to_object!(raw_response)
      expect(response.id).to eq "5cd95395de30eff6ebccde5c"
      expect(response.name).to eq "The Fellowship of the Ring"
      expect(response.runtime_in_minutes).to eq 178
      expect(response.budget_in_millions).to eq 93
      expect(response.box_office_revenue_in_millions).to eq 871.5
      expect(response.academy_award_nominations).to eq 13
      expect(response.academy_award_wins).to eq 4
      expect(response.rotten_tomatoes_score).to eq 91
    end
  end
end
