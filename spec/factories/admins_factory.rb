FactoryBot.define do
  factory :admin do
    username { 'jarvis' }
    email { 'jarvis@mail.com' }
    password { 'passwd' }
    password_confirmation { 'passwd' }
  end
end
