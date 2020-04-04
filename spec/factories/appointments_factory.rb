FactoryBot.define do
  factory :appointment do
    start { "2020-04-04 00:53:38" }
    add_attribute(:end) { "2020-04-04 00:53:38" }
    patient { nil }
    active { false }
  end
end
