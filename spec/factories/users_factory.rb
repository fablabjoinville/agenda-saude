FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "email#{n}@example.org" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
