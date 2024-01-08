FactoryBot.define do
  factory :user do
    sequence(:nickname) { |n| "user#{n}" }

    factory :user_with_2_matches do
      after(:create) do |user|
        create_list(:user_match, 2, user:)
      end
    end
  end
end
