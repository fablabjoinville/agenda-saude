FactoryBot.define do
  factory :appointment do
    start { '2020-01-01 14:00:00'.to_datetime.change(offset: Time.zone.now.strftime('%z')).in_time_zone }
    add_attribute(:end) { '2020-01-01 14:15:00'.to_datetime.change(offset: Time.zone.now.strftime('%z')).in_time_zone }
    patient_id { nil }
    active { true }
    ubs
  end
end
