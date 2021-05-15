FactoryBot.define do
  factory :neighborhood do
    name { |n| "Centro #{n}" }
  end
end
