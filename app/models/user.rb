class User < ApplicationRecord
  has_many :user_matches
  has_many :matches, through: :user_matches

  validates :nickname, uniqueness: true

  def stats
    {
      id:,
      nickname:,
      total_matches:,
      total_points_scored:,
      matches: matches_stats
    }
  end

  def total_matches
    user_matches.count
  end

  def total_points_scored
    points = 0
    user_matches.each do |user_match|
      points += user_match.score
    end
    points
  end

  def matches_stats
    matches_stats = []
    user_matches.each do |user_match|
      matches_stats << {
        match_id: user_match.match.id,
        number_of_rounds: user_match.match.number_of_rounds,
        points_scored: user_match.score
      }
    end
    matches_stats
  end
end
