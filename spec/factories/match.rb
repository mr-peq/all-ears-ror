FactoryBot.define do
  factory :match do
    number_of_rounds { rand(3..10) }

    factory :match_with_3_users do
      after(:create) do |match|
        create_list(:user_match, 3, match:)
      end
    end

    factory :match_custom do
      after(:create) do |match, evaluator|
        evaluator.users.each do |user|
          create(:user_match, match:, user:) unless match.users.include?(user)
        end
      end
    end
  end
end
