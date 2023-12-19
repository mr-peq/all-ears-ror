class Match < ApplicationRecord
  has_many :user_matches
  has_many :users, through: :user_matches

  def stats
    {
      id:,
      number_of_rounds:,
      user_scores:
    }
  end

  def user_scores
    user_scores = []
    user_matches.each do |user_match|
      user_scores << {
        user: user_match.user.nickname,
        score: user_match.score
      }
    end
    user_scores
  end
end
