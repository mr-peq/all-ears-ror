FactoryBot.define do
  factory :match do
    number_of_rounds { rand(3..10) }

    factory :match_with_3_users do
      after(:create) do |match|
        create_list(:user_match, 3, match:)
      end
    end
  end
end
