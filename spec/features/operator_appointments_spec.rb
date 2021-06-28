require 'rails_helper'

RSpec.feature 'Operator appointments' do
  let!(:ubs) { create(:ubs, name: 'Central de Vacinas') }
  let!(:user) { create(:user, ubs: [ubs]) }
  let!(:vaccine) { create(:vaccine, name: 'Vacina', second_dose_after_in_days: 28) }
  let!(:patient) { create(:patient) }

  context 'no appointments' do
    scenario 'shows no appointment', js: true do
      visit new_user_session_path
      fill_in 'Usuário/CNES', with: user.name
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'

      expect(page).to have_content('Logado com sucesso')
      expect(page).to have_content(ubs.name)
      expect(page).to have_content('Nenhum agendamento com os critérios selecionados para este dia.')
    end
  end

  context 'first dose appointment' do
    let!(:first_appointment) do
      create(:appointment, patient: patient, ubs: ubs)
    end

    scenario 'check in and out', js: true do
      visit new_user_session_path
      fill_in 'Usuário/CNES', with: user.name
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'

      expect(page).to have_content('Logado com sucesso')
      expect(page).to have_content(ubs.name)
      expect(page).not_to have_content('Nenhum agendamento com os critérios selecionados para este dia.')
      expect(page).to have_content('1a dose')
      expect(page).to have_content(patient.name)

      click_on 'Check-in'
      page.driver.accept_modal(:confirm) do
        click_on 'Realizar Check-in'
      end

      expect(page).not_to have_content(patient.name)

      click_on 'Aguardando check-out'

      expect(page).to have_content(patient.name)

      click_on 'Check-out'

      expect(page).to have_content('Qual vacina foi aplicada?')

      choose vaccine.name
      page.driver.accept_modal(:confirm) do
        click_on 'Realizar Check-out'
      end

      expect(page).to have_content('tomou a 1a dose')
      expect(page).to have_content('(em 28 dias) na unidade Central de Vacinas para receber Vacina')

      click_on 'Voltar para agendamentos aguardando check-in'

      expect(page).not_to have_content(patient.name)
      click_on 'Vacinado'
      expect(page).to have_content(patient.name)

      # Check as the user

      click_on 'Sair'

      expect(page).to have_content('Saiu com sucesso.')

      fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
      click_on 'Acessar'
      click_on patient.mothers_first_name

      expect(page).to have_content('Sua vacinação agendada')
      expect(page).to have_content("Unidade: #{ubs.name}")
      expect(page).to have_content('Vacinas recebidas')
    end
  end

  context 'second dose appointment' do
    let(:past_date) { vaccine.second_dose_after_in_days.days.ago }
    let!(:first_appointment) do
      create(:appointment, patient: patient, ubs: ubs, start: past_date,
                           end: past_date + ubs.slot_interval_minutes.minutes)
    end

    let!(:second_appointment) do
      s = ReceptionService.new(first_appointment)
      s.check_in(at: past_date)
      s.check_out(vaccine,
                  at: past_date + ubs.slot_interval_minutes.minutes)
       .next_appointment
    end

    scenario 'check in and out', js: true do
      visit new_user_session_path
      fill_in 'Usuário/CNES', with: user.name
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'

      expect(page).to have_content('Logado com sucesso')
      expect(page).to have_content(ubs.name)
      expect(page).not_to have_content('Nenhum agendamento com os critérios selecionados para este dia.')
      expect(page).to have_content('2a dose')
      expect(page).to have_content(patient.name)

      click_on 'Check-in'
      page.driver.accept_modal(:confirm) do
        click_on 'Realizar Check-in'
      end

      expect(page).not_to have_content(patient.name)

      click_on 'Aguardando check-out'

      expect(page).to have_content(patient.name)

      click_on 'Check-out'

      expect(page).to have_content('Paciente obrigatoriamente deverá receber o reforço com a vacina Vacina.')

      page.driver.accept_modal(:confirm) do
        click_on 'Realizar Check-out'
      end

      expect(page).to have_content('está imunizado(a)')
      expect(page).to have_content('1a dose da Vacina')
      expect(page).to have_content('2a dose da Vacina')

      click_on 'Voltar para agendamentos aguardando check-in'

      expect(page).not_to have_content(patient.name)
      click_on 'Vacinado'
      expect(page).to have_content(patient.name)

      # Check as the user

      click_on 'Sair'

      expect(page).to have_content('Saiu com sucesso.')

      fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
      click_on 'Acessar'
      click_on patient.mothers_first_name

      expect(page).to have_content('Paciente imunizado')
    end
  end
end
