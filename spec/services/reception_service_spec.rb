require 'rails_helper'

RSpec.describe ReceptionService, type: :service do
  # Eager UBS creation required because of patient.set_main_ubs
  let!(:ubs) { create(:ubs) }
  let(:appointment) { create(:appointment, patient_id: patient.id) }
  let(:patient) { create(:patient) }
  let(:service) { ReceptionService.new(appointment) }
  let(:time) { Time.new('2020-01-01') }
  let(:vaccine_name) { 'coronavac' }

  before do
    travel_to time
  end

  describe '#check in' do
    it 'updates check in attribute' do
      expect { service.check_in }.to change { appointment.reload.check_in }.from(nil).to(time)
    end
  end

  describe '#check out' do
    it 'updates vaccine_name on first dose' do
      expect { service.check_out(vaccine_name) }
        .to change { appointment.reload.vaccine_name }.from(nil).to(vaccine_name)
    end

    it 'updates vaccine_name on second_dose' do
      expect { service.check_out(vaccine_name) }
        .to change { patient.appointments.current.reload.vaccine_name }.from(nil).to(vaccine_name)
    end

    it 'updates check out attribute' do
      expect { service.check_out(vaccine_name) }
        .to change { appointment.reload.check_out }.from(nil).to(time)
    end

    it 'marks last_appointment as a second dose appointment' do
      service.check_out(vaccine_name)

      expect(patient.appointments.current.second_dose).to eq(true)
    end

    it 'schedules second dose appointment' do
      expect { service.check_out(vaccine_name) }
        .to change { patient.appointments.count }.from(1).to(2)
    end

    context "when the pacient check's out from second dose appointment" do
      let(:second_appointment) { create(:appointment, patient_id: patient.id, second_dose: true, vaccine_name: vaccine_name) }
      let(:service) { ReceptionService.new(second_appointment) }

      it 'updates the patient last_appointment attribute' do
        expect { service.check_out(vaccine_name) }
          .not_to change { patient.appointments.current.id }
      end

      it 'does not schedules a new appointment' do
        service.check_out(vaccine_name)

        expect(Appointment.where(patient_id: patient.id).count).to eq(2)
      end
    end
  end
end
