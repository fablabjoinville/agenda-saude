FactoryBot.define do
  factory :vaccine do
    name { "Vacina" }
    full_name { "Vacina Boa" }
    second_dose_after_in_days { 28 }
    legacy_name { "vacina" }
  end
end
