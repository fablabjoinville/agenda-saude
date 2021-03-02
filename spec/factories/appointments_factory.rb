FactoryBot.define do
  factory :appointment do
    start { start_time }
    add_attribute(:end) { end_time }
    patient_id { nil }
    ubs { find_or_create_ubs }
  end
end

def find_or_create_ubs
  Ubs.first || create(:ubs)
end

def start_time
  '2020-01-01 14:00:00'.to_datetime.change(offset: Time.zone.now.strftime('%z')).in_time_zone
end

def end_time
  '2020-01-01 14:15:00'.to_datetime.change(offset: Time.zone.now.strftime('%z')).in_time_zone
end
