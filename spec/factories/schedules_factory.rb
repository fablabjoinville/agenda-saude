FactoryBot.define do
  factory :schedule do
    patient { nil }
    appointment { nil }
    checked_in_at { "2021-04-03 15:12:55" }
    checked_out_at { "2021-04-03 15:12:55" }
    canceled_at { "2021-04-03 15:12:55" }
    canceled_reason { "MyString" }
  end
end
