class User < ApplicationRecord
  has_many :user_matches
  has_many :matches, through: :user_matches
end
