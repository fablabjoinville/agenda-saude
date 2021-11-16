FactoryBot.define do
  factory :ubs, class: 'Ubs' do
    name { 'UBS Norte' }
    neighborhood { create(:neighborhood) }
    neighborhoods { [] }
    shift_start { '08:00' }
    shift_end { '18:00' }
    break_start { '12:00' }
    break_end { '13:00' }
    slot_interval_minutes { 15 }
    sequence(:cnes) { |n| n }
    phone { '9999-8888' }
    address { 'Rua Principal, 256' }
    active { true }
  end

  factory :ubs_for_reschedule, class: 'Ubs' do
    name { 'UBS Sul' }
    neighborhood { create(:neighborhood) }
    neighborhoods { [] }
    shift_start { '08:00' }
    shift_end { '18:00' }
    break_start { '12:00' }
    break_end { '13:00' }
    slot_interval_minutes { 15 }
    sequence(:cnes) { |n| n }
    phone { '9999-8888' }
    address { 'Rua Secundaria, 256' }
    active { true }
    enabled_for_reschedule { true }
  end
end
