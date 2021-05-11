FactoryBot.define do
  factory :condition do
    name { 'População em geral de maior' }
    start_at { 1.minute.ago }
    end_at { 1.month.from_now }
    min_age { 18 }
    ubs do
      ubs = Ubs.all
      ubs = [create(:ubs)] if ubs.empty?
      ubs
    end
  end
end
