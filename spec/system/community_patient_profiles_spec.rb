require 'rails_helper'

RSpec.describe 'Patients managing their profiles', type: :system do
  let!(:neighborhood) { create(:neighborhood) }
  let!(:group) { create(:group) }

  scenario 'sign up with a new patient' do
    visit root_path
    fill_in 'patient_cpf', with: '832.742.297-92'
    click_on 'Acessar'

    fill_in 'Nome completo', with: 'Marvin'
    select '1', from: 'patient_birthday_3i'
    select 'janeiro', from: 'patient_birthday_2i'
    select '1950', from: 'patient_birthday_1i'
    fill_in 'Nome completo da mãe', with: 'Tristeza'

    check group.name

    fill_in 'Endereço', with: 'Rua das Flores'
    fill_in 'Número', with: '1'
    fill_in 'Complemento', with: 'Ap 101'
    select neighborhood.name, from: 'Bairro'
    fill_in 'Telefone', with: '47999999999'
    fill_in 'Telefone Secundário', with: '47999999990'
    fill_in 'Email', with: 'marvin@vacinajoinville.com.br'
    fill_in 'Número do cartão SUS', with: '957774523900005'

    click_on 'Cadastrar'
    expect(page).to have_content('Seu cadastro foi realizado com sucesso')
  end
end
