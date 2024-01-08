require 'rails_helper'

RSpec.describe Match, type: :model do
  let(:user_match) { create(:user_match) }
  let(:match) { user_match.match }

  describe "#stats" do
    it "returns match details" do
      result = match.stats
      expect( result ).to be_a Hash
      expect( result.keys ).to include(:id, :number_of_rounds, :user_scores )
    end
  end

  describe '#user_scores' do
    it "returns the score for each user in a match" do
      result = match.user_scores
      expect( result ).to be_a Array
      expect( result[0].keys ).to include(:user, :score)
    end
  end

  describe 'match creation' do
    it "A match should not be persisted in db if its number_of_rounds is < 3" do
      invalid_match = Match.new(number_of_rounds: 2)
      expect( invalid_match.valid? ).to eq(false)
    end
    it "A match should not be persisted in db if its number_of_rounds is > 10" do
      invalid_match = Match.new(number_of_rounds: 11)
      expect( invalid_match.valid? ).to eq(false)
    end
  end
end
