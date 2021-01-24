require 'rails_helper'

RSpec.describe ReceptionService, type: :service do
  let(:appointment) { create(:appointment) }
  let!(:next_appointment) { create(:appointment, start: appointment.start + ENV['SECOND_DOSE_INTERVAL'].to_i.weeks) }
  let(:patient) { create(:patient) }
  let(:service) { ReceptionService.new(patient) }
  let(:time) { Time.new('2020-01-01') }

  before do
    travel_to time
    schedule_appointment
  end

  after { travel_back }

  describe '#check in' do
    it 'updates check in attribute' do
      expect { service.check_in }.to change { appointment.reload.check_in }.from(nil).to(time)
    end
  end

  describe '#check out' do
    it 'updates check out attribute' do
      expect { service.check_out }.to change { appointment.reload.check_out }.from(nil).to(time)
    end

    it 'updates the patient last_appointment attribute' do
      expect { service.check_out }.to change { patient.reload.last_appointment }.from(appointment.start).to(next_appointment.start)
    end

    it 'marks next_appointment as a second dose appointment' do
      expect { service.check_out }.to change { next_appointment.reload.second_dose }.from(false).to(true)
    end

    it 'schedules second dose appointment' do
      expect { service.check_out }.to change { next_appointment.reload.patient_id }.from(nil).to(patient.id)
    end

    context "when the pacient check's out from second dose appointment" do
      it 'does not schedules a new appointment' do
        # TODO
      end
    end
  end

  def schedule_appointment
    appointment.update!(patient_id: patient.id)
    patient.update!(last_appointment: appointment.start)
  end
end
