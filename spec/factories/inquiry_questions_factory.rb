FactoryBot.define do
  factory :inquiry_question do
    text { "MyString" }
    form_type { 1 }
    position { 1 }
    active { "" }
  end
end
