FactoryBot.define do
  factory :vaccine do
    name { 'Vacina' }
    formal_name { 'Vacina Boa' }
    second_dose_after_in_days { 28 }
  end
end
