FactoryBot.define do
  factory :dose do
    patient { nil }
    vaccine { nil }
    sequence_number { 1 }
  end
end
