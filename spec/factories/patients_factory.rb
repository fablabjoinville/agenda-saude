FactoryBot.define do
  factory :patient do
    name { 'Fulano da Silva' }
    cpf { '81220540056' }
    mother_name { 'Maria da Silva' }
    birth_date { '1950-01-01' }
    phone { '(47) 99999-9999' }
    neighborhood { create(:neighborhood) }
    public_place { 'Rua das Flores' }
    place_number { '1' }

    # other_phone { '(47) 99999-9999' }
    # email { 'paciente@example.org' }
    # sus { '1234567890' }
  end
end
