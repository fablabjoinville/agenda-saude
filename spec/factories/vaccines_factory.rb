FactoryBot.define do
  factory :vaccine do
    name { 'Vacina' }
    formal_name { 'Vacina Boa' }
    second_dose_after_in_days { 28 }
  end

  factory :pfizer_vaccine, class: 'Vaccine' do
    name { 'Pfizer' }
    formal_name { 'Pfizer–BioNTech COVID-19 Comirnaty' }
    second_dose_after_in_days { 85 }
  end
end
