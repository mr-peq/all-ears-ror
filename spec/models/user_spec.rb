require 'rails_helper'

RSpec.describe User, type: :model do
  user = User.find_by(nickname: 'allen')
  match = Match.create(number_of_rounds: rand(3..10))
  UserMatch.create(user:, match:, score: 2)

  describe '#total_matches' do
    it "returns the total number of matches" do
      expect( user.total_matches ).to eq(2)
    end
  end

  describe '#total_points_scored' do
    it "returns the total number of points scored" do
      expect( user.total_points_scored ).to eq(4)
    end
  end

  describe '#matches_stats' do
    it "returns detailed stats for each match played by the user" do
      expect( user.matches_stats ).to be_a Array
      expect( user.matches_stats.last ).to be_a Hash
      expect( user.matches_stats.last.keys ).to include(:match_id, :number_of_rounds, :points_scored)
    end
  end

  describe '#stats' do
    it "returns the user's stats" do
      expect( user.stats ).to be_a Hash
      expect( user.stats.keys ).to include(:id, :nickname, :total_matches, :total_points_scored, :matches)
      expect( user.stats[:total_matches]).to eq(user.total_matches)
      expect( user.stats[:total_points_scored]).to eq(user.total_points_scored)
    end
  end
end
