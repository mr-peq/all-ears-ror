require 'rails_helper'

RSpec.describe Match, type: :model do
  let(:match) { build(:match) }
  
  describe "#stats" do
    it "returns match details" do
      result = match.stats
      expect( result ).to be_a Hash
      expect( result.keys ).to include(:id, :number_of_rounds, :user_scores )
    end
  end

  describe '#user_scores' do
    it "returns he score for each user in a match"
  end
end
