FactoryBot.define do
  factory :vaccine do
    name { "Vacina" }
    formal_name { "Vacina Boa" }
    second_dose_after_in_days { 28 }
    legacy_name { "vacina" }

    trait :coronavac do
      name { "CoronaVac" }
      formal_name { "Sinovac COVID-19 CoronaVac" }
      second_dose_after_in_days { 4 * 7 }
      legacy_name { "coronavac" }
    end

    trait :astra_zeneca do
      name { "AstraZeneca" }
      formal_name { "Oxford–AstraZeneca COVID-19 ChAdOx1 (AZD1222)" }
      second_dose_after_in_days { 12 * 7 }
      legacy_name { "astra_zeneca" }
    end
  end
end
