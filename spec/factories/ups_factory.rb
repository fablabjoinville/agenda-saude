FactoryBot.define do
  factory :up, class: 'Ups' do
    name { "MyString" }
    neighborhood { "MyString" }
    user { nil }
    shift_start { "2020-04-04 00:53:36" }
    shift_end { "2020-04-04 00:53:36" }
    break_start { "2020-04-04 00:53:36" }
    break_end { "2020-04-04 00:53:36" }
  end
end
