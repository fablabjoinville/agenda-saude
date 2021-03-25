require 'rails_helper'

RSpec.describe ReceptionService, type: :service do
  # Eager UBS creation required because of patient.set_main_ubs
  let!(:ubs) { create(:ubs) }
  let!(:appointment) { create(:appointment, patient: patient) }
  let(:patient) { create(:patient) }
  let(:time) { Time.new('2020-01-01') }
  let(:vaccine_name) { 'coronavac' }
  let(:service) { described_class.new(appointment) }

  before do
    travel_to time
  end

  describe '#check in' do
    it 'updates check in attribute' do
      expect { service.check_in }.to change { appointment.check_in }.from(nil).to(time)
    end
  end

  describe '#check out' do
    it 'updates vaccine_name on first dose' do
      expect { service.check_out(vaccine_name) }
        .to change { appointment.vaccine_name }.from(nil).to(vaccine_name)
    end

    it 'updates vaccine_name on second_dose' do
      expect { service.check_out(vaccine_name) }
        .to change { patient.appointments.current.vaccine_name }.from(nil).to(vaccine_name)
    end

    it 'updates check out attribute' do
      expect { service.check_out(vaccine_name) }
        .to change { appointment.check_out }.from(nil).to(time)
    end

    it 'marks last_appointment as a second dose appointment' do
      service.check_out(vaccine_name)

      expect(patient.appointments.current.second_dose).to eq(true)
    end

    it 'schedules second dose appointment' do
      expect { service.check_out(vaccine_name) }
        .to change { patient.appointments.count }.from(1).to(2)
    end

    context "when the patient check's out from second dose appointment" do
      let!(:second_appointment) do
        create(:appointment, patient: patient, vaccine_name: vaccine_name, start: 15.minutes.from_now,
               second_dose: true)
      end
      let(:service) { described_class.new(second_appointment) }

      before do
        appointment.update!(vaccine_name: vaccine_name, check_out: appointment.start)
      end

      it 'updates the patient last_appointment attribute' do
        expect { service.check_out(vaccine_name) }
          .not_to change { patient.appointments.current.id }
      end

      it 'does not schedules a new appointment' do
        service.check_out(vaccine_name)

        expect(patient.appointments.count).to eq(2)
      end
    end
  end
end
