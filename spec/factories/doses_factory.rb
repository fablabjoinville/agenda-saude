FactoryBot.define do
  factory :dose do
    patient { nil }
    schedule { nil }
    vaccine { nil }
    sequence_number { 1 }
  end
end
