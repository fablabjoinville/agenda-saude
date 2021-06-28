FactoryBot.define do
  factory :appointment do
    start { 1.minute.from_now }
    add_attribute(:end) { 1.minute.from_now + ubs.slot_interval_minutes.minutes }
    patient_id { nil }
    active { true }
    ubs
  end
end
