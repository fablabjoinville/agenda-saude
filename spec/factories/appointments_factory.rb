FactoryBot.define do
  factory :appointment do
    start { '2020-01-01 14:00:00' }
    add_attribute(:end) { '2020-01-01 14:15:00' }
    patient { create(:patient) }
    ubs { create(:ubs) }
    active { true }
  end
end
