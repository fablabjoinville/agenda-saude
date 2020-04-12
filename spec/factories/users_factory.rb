FactoryBot.define do
  factory :user do
    email { 'email@domain.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
