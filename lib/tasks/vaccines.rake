namespace :seeding do
  desc "Create default vaccines"
  task vaccines: :environment do
    [
      { id: 1, name: 'CoronaVac', formal_name: 'Sinovac COVID-19 CoronaVac',
        second_dose_after_in_days: 4 * 7, legacy_name: 'coronavac' },
      { id: 2, name: 'AstraZeneca', formal_name: 'Oxford–AstraZeneca COVID-19 ChAdOx1 (AZD1222)',
        second_dose_after_in_days: 13 * 7, legacy_name: 'astra_zeneca' }
    ].each do |h|
      Vaccine.find_or_initialize_by(id: h[:id]).tap { |r| r.update!(h) }
    end
  end
end
