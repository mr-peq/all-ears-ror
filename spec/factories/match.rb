FactoryBot.define do
  factory :match do
    number_of_rounds { rand(3..10) }
  end
end
