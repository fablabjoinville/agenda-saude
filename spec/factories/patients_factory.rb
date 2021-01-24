FactoryBot.define do
  factory :patient do
    name { 'My String' }
    cpf { '81220540056' }
    mother_name { 'MyString' }
    birth_date { '1900-01-01' }
    phone { '(47) 3443-3443' }
    other_phone { 'MyString' }
    email { 'MyString' }
    sus { 'MyString' }
    neighborhood { 'MyString' }
  end
end
