require 'rails_helper'

RSpec.feature 'Patients managing their appointments' do
  let!(:neighborhood) { create(:neighborhood) }
  let!(:group) { create(:group) }
  let!(:ubs) { create(:ubs) }
  let!(:patient) { create(:patient) }

  let(:tomorrow_morning) { 1.day.from_now.beginning_of_day + 7.hours }

  context 'patient without appointment' do
    context 'patient cannot schedule' do
      scenario 'see notification' do
        visit root_path
        fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
        click_on 'Acessar'
        click_on patient.mothers_first_name

        expect(page).to have_content('não há doses disponíveis para o seu grupo prioritário')
      end
    end

    context 'patient can schedule' do
      let!(:condition) { create(:condition, min_age: 18, max_age: nil, group_ids: [], can_schedule: true) }

      scenario 'no available doses' do
        visit root_path
        fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
        click_on 'Acessar'
        click_on patient.mothers_first_name

        expect(page).to have_content('Aguardando novas doses')
      end

      scenario 'there are available doses' do
        Appointment.create!(ubs: ubs, start: tomorrow_morning, end: tomorrow_morning + 15.minutes)

        visit root_path
        fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
        click_on 'Acessar'
        click_on patient.mothers_first_name

        expect(page).to have_content('Temos 1 doses disponíveis')
        click_on 'Agendar sua vacina'

        expect(page).to have_content('Unidades com disponibilidade nesta data')

        click_on ubs.name
        click_on '07:00'

        expect(page).to have_content('Vacinação agendada')
        expect(page).to have_content("Unidade: #{ubs.name}")
        expect(page).to have_content('às 07:00')
      end
    end
  end

  context 'patient with first dose appointment' do
    let!(:condition) { create(:condition, min_age: 18, max_age: nil, group_ids: [], can_schedule: true) }
    let!(:appointment) do
      patient.appointments.create!(ubs: ubs, start: tomorrow_morning, end: tomorrow_morning + 15.minutes)
    end

    scenario 'can see it' do
      visit root_path
      fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
      click_on 'Acessar'
      click_on patient.mothers_first_name

      expect(page).to have_content('Sua vacinação agendada')
      expect(page).to have_content("Unidade: #{ubs.name}")
      expect(page).to have_content('às 07:00')
    end

    scenario 'can cancel it' do
      visit root_path
      fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
      click_on 'Acessar'
      click_on patient.mothers_first_name

      expect(page).to have_content('Cancelar este agendamento')
      page.driver.accept_modal(:confirm) do
        click_on 'Cancelar este agendamento'
      end

      expect(page).to have_content('Temos 1 doses disponíveis')
      expect(page).to have_content('Agendar sua vacina')
    end

    describe 'can reschedule it' do
      scenario 'and there are more doses' do
        Appointment.create!(ubs: ubs, start: tomorrow_morning + 1.hour, end: tomorrow_morning + 1.hour + 15.minutes)

        visit root_path
        fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
        click_on 'Acessar'
        click_on patient.mothers_first_name

        click_on 'Reagendar e escolher outro dia, horário ou local'

        expect(page).to have_content('Unidades com disponibilidade nesta data')

        click_on ubs.name
        click_on '08:00'

        expect(page).to have_content('Vacinação agendada')
        expect(page).to have_content("Unidade: #{ubs.name}")
        expect(page).to have_content('às 08:00')

        # Try to reschedule previous one...

        click_on 'Reagendar e escolher outro dia, horário ou local'

        expect(page).to have_content('Unidades com disponibilidade nesta data')

        click_on ubs.name
        click_on '07:00'

        expect(page).to have_content('Vacinação agendada')
        expect(page).to have_content("Unidade: #{ubs.name}")
        expect(page).to have_content('às 07:00')
      end

      scenario 'but there are no more doses' do
        visit root_path
        fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
        click_on 'Acessar'
        click_on patient.mothers_first_name

        click_on 'Reagendar e escolher outro dia, horário ou local'

        expect(page).not_to have_content('Unidades com disponibilidade nesta data')
        expect(page).to have_content('Não há vagas disponíveis para reagendamento.')
      end
    end

    scenario 'cannot change their profile to be outside allowed condition' do
      visit root_path
      fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
      click_on 'Acessar'
      click_on patient.mothers_first_name

      click_on 'Alterar meus dados'
      select 13.years.ago.year.to_s, from: 'patient_birthday_1i'
      click_on 'Atualizar'

      expect(page).to have_content('Não foi possível atualizar seu cadastro')
      expect(patient.reload.age).not_to be(13)
    end
  end

  context 'patient with second dose appointment' do
    let(:vaccine) { create(:vaccine) }
    let!(:condition) { create(:condition, min_age: 18, max_age: nil, group_ids: [], can_schedule: true) }
    
    context 'to have second dose in the future' do
      let!(:first_appointment_day) { vaccine.second_dose_after_in_days.days.ago.beginning_of_day + 1.days + 7.hours }
      let!(:first_appointment) do
        patient.appointments.create!(ubs: ubs,
                                     start: first_appointment_day,
                                     end: first_appointment_day + ubs.slot_interval_minutes.minutes)
      end

      let!(:second_appointment) do
        s = ReceptionService.new(first_appointment)
        s.check_in(at: first_appointment_day)
        s.check_out(vaccine,
                    at: first_appointment_day + ubs.slot_interval_minutes.minutes)
         .next_appointment
      end

      scenario 'can see it but cannot change it' do
        visit root_path
        fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
        click_on 'Acessar'
        click_on patient.mothers_first_name

        expect(page).to have_content('Sua vacinação agendada')
        expect(page).to have_content("Unidade: #{ubs.name}")
        expect(page).to have_content('às 07:00')
        expect(page).to have_content('Vacina: Vacina')
        expect(page).to have_content('Vacinas recebidas')
        expect(page).to have_content('Ainda falta muito tempo para o reforço da sua vacina')
      end
    end

    context 'to have second dose today' do
      let(:past_date) { vaccine.second_dose_after_in_days.days.ago - 1.hour }

      let!(:first_appointment) do
        patient.appointments.create!(ubs: ubs,
                                     start: past_date,
                                     end: past_date + ubs.slot_interval_minutes.minutes)
      end

      let!(:second_appointment) do
        s = ReceptionService.new(first_appointment)
        s.check_in(at: past_date)
        s.check_out(vaccine,
                    at: past_date + ubs.slot_interval_minutes.minutes)
         .next_appointment
      end

      scenario 'can see and change it' do
        visit root_path
        fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
        click_on 'Acessar'
        click_on patient.mothers_first_name

        expect(page).to have_content('Sua vacinação agendada')
        expect(page).to have_content("Unidade: #{ubs.name}")
        expect(page).to have_content('Vacina: Vacina')
        expect(page).to have_content('Vacinas recebidas')
        expect(page).to have_content('Ainda falta muito tempo para o reforço da sua vacina')
      end

      context 'no more appointments available' do
        scenario 'can cancel it and see there are no doses available' do
          visit root_path
          fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
          click_on 'Acessar'
          click_on patient.mothers_first_name

          expect(page).to have_content('Cancelar este agendamento')
          page.driver.accept_modal(:confirm) do
            click_on 'Cancelar este agendamento'
          end

          expect(page).to have_content('Aguardando novas doses')
          expect(page).to have_content('Vacinas recebidas')
        end
      end

      context 'appointments available' do
        let!(:ubs_for_reschedule) { create(:ubs_for_reschedule) }

        scenario 'can reschedule with same vaccine' do
          Appointment.create!(ubs: ubs_for_reschedule, start: tomorrow_morning, end: tomorrow_morning + 15.minutes)

          visit root_path
          fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
          click_on 'Acessar'
          click_on patient.mothers_first_name

          click_on 'Reagendar e escolher outro dia, horário ou local'

          expect(page).to have_content('Unidades com disponibilidade nesta data')

          click_on ubs_for_reschedule.name
          click_on '07:00'

          expect(page).to have_content('Vacinação agendada')
          expect(page).to have_content("Unidade: #{ubs_for_reschedule.name}")
          expect(page).to have_content('às 07:00')
          expect(page).to have_content('Vacinas recebidas')
        end
      end
    end
  end

  context 'patient is vaccinated' do
    let(:past_date) { vaccine.second_dose_after_in_days.days.ago }
    let(:vaccine) { create(:vaccine) }
    let!(:condition) { create(:condition, min_age: 18, max_age: nil, group_ids: [], can_schedule: true) }
    let!(:first_appointment) do
      patient.appointments.create!(ubs: ubs,
                                   start: past_date,
                                   end: past_date + ubs.slot_interval_minutes.minutes)
    end

    let!(:second_appointment) do
      s = ReceptionService.new(first_appointment)
      s.check_in(at: past_date)
      second = s.check_out(vaccine,
                           at: past_date + ubs.slot_interval_minutes.minutes)
                .next_appointment

      s = ReceptionService.new(second)
      s.check_in
      s.check_out(vaccine)
      second
    end

    scenario 'can see it but cannot change it' do
      visit root_path
      fill_in 'patient_cpf', with: ApplicationHelper.humanize_cpf(patient.cpf)
      click_on 'Acessar'
      click_on patient.mothers_first_name

      expect(page).to have_content('Paciente imunizado')
    end
  end
end
