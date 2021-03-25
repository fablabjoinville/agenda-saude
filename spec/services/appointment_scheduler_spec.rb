require 'rails_helper'

# Need to disable transactional tests because AppointmentScheduler opens a
# transaction, which will be nested within RSpec transaction, causing the
# :isolation option to fail as it's only allowed for top-level transactions
RSpec.describe AppointmentScheduler, type: :service, use_transactional_tests: false do
  let(:max_schedule_time_ahead) { 3.days }
  let(:scheduler) do
    AppointmentScheduler.new(
      max_schedule_time_ahead: max_schedule_time_ahead
    )
  end
  # Eager UBS creation required because of patient.set_main_ubs
  let!(:ubs) { create(:ubs, active: true) }
  let(:patient) { create(:patient, cpf: '29468604004') }
  let(:start_time) { '2020-01-01 12:40:00 -0300' }
  let(:args) do
    { raw_start_time: start_time, ubs: ubs, patient: patient }
  end
  let(:time) { Time.new('2020-01-01') }

  before { travel_to time }
  after { travel_back }

  before do
    allow(patient).to receive(:can_schedule?).and_return(true)
  end

  describe 'when ubs is inactive' do
    before do
      ubs.update!(active: false)
    end

    it 'returns an :inactive_ubs result' do
      expect(scheduler.schedule(**args)).to eq([:inactive_ubs])
    end

    it 'does not update any appointment' do
      expect { scheduler.schedule(**args) }
        .not_to change { Appointment.all.map(&:attributes) }
    end
  end

  describe 'when all slots were taken' do
    before do
      create_list(
        :appointment,
        3,
        start: start_time,
        ubs: ubs,
        patient: create(:patient)
      )
    end

    it 'does not update any appointment' do
      expect { scheduler.schedule(**args) }
        .not_to change { Appointment.all.map(&:attributes) }
    end

    it 'returns an :all_slots_taken result' do
      expect(scheduler.schedule(**args)).to eq([:all_slots_taken])
    end
  end

  describe 'when patient cannot schedule' do
    before do
      allow(patient).to receive(:can_schedule?).and_return(false)
    end

    it 'returns a :schedule_conditions_unmet result' do
      expect(scheduler.schedule(**args)).to eq([:schedule_conditions_unmet])
    end

    it 'does not update any appointment' do
      expect { scheduler.schedule(**args) }
        .not_to change { Appointment.all.map(&:attributes) }
    end
  end

  describe 'when start time is past allowed window' do
    let(:start_time) { time + max_schedule_time_ahead + 1.day }
    let(:schedule) do
      scheduler.schedule(raw_start_time: start_time.to_s, patient: patient, ubs: ubs)
    end

    before do
      create(:appointment, start: start_time, ubs: ubs, patient_id: nil)
    end

    it 'returns an :invalid_schedule_time result' do
      expect(schedule).to eq([:invalid_schedule_time])
    end

    it 'does not update any appointment' do
      expect { schedule }.not_to change { Appointment.all.map(&:attributes) }
    end
  end

  describe 'when there are free time slots' do
    before do
      create_list(
        :appointment,
        3,
        start: start_time,
        ubs: ubs,
        patient: nil
      )
    end

    it 'updates exactly one appointment' do
      expect(Appointment.count).to eq(3)
      expect {
        expect(scheduler.schedule(**args))
          .to eq([:success, Appointment.find_by(patient_id: patient.id)])
      }.to change { Appointment.where(patient_id: nil).count }.from(3).to(2)
    end
  end

  describe 'when an exception is thrown' do
    it 'returns an :internal_error result along with the error message' do
      result, data = scheduler.schedule(raw_start_time: 'invalid', **args.except(:raw_start_time))

      expect(result).to eq(:internal_error)
      expect(data).to eq('no time information in "invalid"')
    end
  end
end
