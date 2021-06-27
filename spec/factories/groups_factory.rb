FactoryBot.define do
  factory :group do
    name { |n| "Grupo #{n.object_id}" }
  end
end
