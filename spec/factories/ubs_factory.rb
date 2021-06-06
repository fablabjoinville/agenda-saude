FactoryBot.define do
  factory :ubs, class: 'Ubs' do
    name { 'UBS Norte' }
    neighborhood
    neighborhoods { [] }
    shift_start { '08:00' }
    shift_end { '18:00' }
    break_start { '12:00' }
    break_end { '13:00' }
    slot_interval_minutes { 15 }
    sequence(:cnes) { |n| n }
    phone { '9999-8888' }
    address { 'Rua Principal, 256' }
  end
end
