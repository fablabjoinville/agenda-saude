require 'rails_helper'

RSpec.feature 'Patients managing their profiles' do
  let!(:neighborhood) { create(:neighborhood) }
  let!(:group) { create(:group) }

  scenario 'sign up with a new patient', js: true do
    visit root_path
    fill_in 'patient_cpf', with: '832.742.297-92'
    click_on 'Acessar'

    fill_in 'Nome completo', with: 'Marvin'
    select '1', from: 'patient_birthday_3i'
    select 'janeiro', from: 'patient_birthday_2i'
    select 30.years.ago.year.to_s, from: 'patient_birthday_1i'
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

  scenario 'patient already exists', js: true do
    patient = create(:patient)

    visit root_path
    fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
    click_on 'Acessar'

    expect(page).to have_content('Validação de segurança')
    click_on patient.mothers_first_name
    expect(page).to have_content('Você não possui vacinação agendada')
  end

  scenario 'patient must update their profile' do
    patient = create(:patient, user_updated_at: 100.years.ago)

    visit root_path
    fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
    click_on 'Acessar'

    expect(page).to have_content('Validação de segurança')
    click_on patient.mothers_first_name
    expect(page).to have_content('Por favor, atualize seu cadastro para continuar a acessar o agendamento.')
    click_on 'Atualizar'

    expect(page).to have_content('Você não possui vacinação agendada')
  end

  scenario 'patient can update their profile' do
    patient = create(:patient)
    expect(patient.name).not_to eq('Atualizaldo')

    visit root_path
    fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
    click_on 'Acessar'

    expect(page).to have_content('Validação de segurança')
    click_on patient.mothers_first_name

    click_on 'Alterar meus dados'
    fill_in 'Nome completo', with: 'Atualizaldo'
    click_on 'Atualizar'

    expect(patient.reload.name).to eq('Atualizaldo')
  end
end
