[
  { name: 'CoronaVac', formal_name: 'Sinovac COVID-19 CoronaVac',
    second_dose_after_in_days: 4 * 7 },
  { name: 'AstraZeneca', formal_name: 'Oxford–AstraZeneca COVID-19 ChAdOx1 (AZD1222)',
    second_dose_after_in_days: 13 * 7 }
].each do |h|
  Vaccine.find_or_initialize_by(name: h[:name]).tap { |r| r.update!(h) }
end
