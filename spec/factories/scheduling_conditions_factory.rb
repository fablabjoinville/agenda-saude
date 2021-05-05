FactoryBot.define do
  factory :scheduling_condition do
    name { 'População em geral de maior' }
    start_at { 1.minute.ago }
    min_age { 18 }
    active { true }
  end
end
