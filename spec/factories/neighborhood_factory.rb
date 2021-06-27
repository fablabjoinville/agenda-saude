FactoryBot.define do
  factory :neighborhood do
    name { |n| "Centro #{n.object_id}" }
  end
end
