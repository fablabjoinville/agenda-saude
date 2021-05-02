require 'rails_helper'

RSpec.describe ReceptionService, type: :service do
  let!(:ubs) { create(:ubs) }
  let!(:appointment) { create(:appointment, patient: patient) }
  let!(:vaccine) { Vaccine.find_by(legacy_name: vaccine_name) || create(:vaccine, legacy_name: vaccine_name) }
  let(:patient) { create(:patient) }
  let(:time) { Time.zone.local('2020-01-01') }
  let(:vaccine_name) { 'coronavac' }
  let(:service) { described_class.new(appointment) }

  before do
    travel_to time
  end

  context 'first dose' do
    describe 'check in' do
      it 'updates check in attribute' do
        expect { service.check_in }.to change { appointment.check_in }.from(nil).to(time)
      end
    end

    describe 'check out' do
      it 'updates vaccine_name' do
        expect { service.check_out(vaccine) }
          .to change { appointment.vaccine_name }
          .from(nil)
          .to(vaccine_name)
      end
      it 'updates dose_vaccine' do
        expect { service.check_out(vaccine) }
          .to change { appointment.dose_vaccine }
          .from(nil)
          .to(vaccine)
      end
      it 'maintains dose_sequence_number' do
        service.check_out(vaccine)
        expect(appointment.dose_sequence_number).to eq(1)
      end
      it 'updates check_out' do
        expect { service.check_out(vaccine) }
          .to change { appointment.check_out }
          .from(nil)
          .to(time)
      end

      it 'creates second dose' do
        expect(patient.appointments.count).to eq(1)
        result = service.check_out(vaccine)

        follow_up = result.next_appointment
        first_dose = result.dose

        expect(follow_up).not_to be_nil
        expect(first_dose).not_to be_nil

        expect(first_dose).to eq(patient.doses.first!)
        expect(follow_up).to eq(first_dose.follow_up_appointment)

        expect(follow_up).to be_kind_of(Appointment)
        expect(patient.appointments.count).to eq(2)
        expect(follow_up.follow_up_for_dose).to eq(first_dose)
      end

      it 'have checked out appointment and new current appointment' do
        service.check_out(vaccine)

        expect(patient.appointments.checked_out.count).to eq(1)
        expect(patient.appointments.current).to be_waiting

        expect(patient.appointments.current.id).not_to be_in(patient.appointments.checked_out.pluck(:id))
      end
    end

    context 'second dose' do
      let(:second_appointment) do
        first_service = described_class.new(appointment)
        first_service.check_in
        result = first_service.check_out(vaccine)
        result.next_appointment
      end
      let(:service) { described_class.new(second_appointment) }

      it 'does not schedules a new appointment' do
        service.check_out(vaccine)

        expect(patient.appointments.count).to eq(2)
      end
    end
  end
end
