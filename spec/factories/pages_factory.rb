FactoryBot.define do
  factory :page do
    path { "MyString" }
    title { "MyString" }
    body { "MyText" }
    context { 1 }
  end
end
