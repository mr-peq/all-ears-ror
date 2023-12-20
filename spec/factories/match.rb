FactoryBot.define do
  factory :match do
    number_of_rounds { [1..10].sample }
  end
end
