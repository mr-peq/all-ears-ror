FactoryBot.define do
  factory :user_match do
    user
    match
    score { 2 }
  end
end
