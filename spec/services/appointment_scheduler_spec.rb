require 'rails_helper'

# Need to disable transactional tests because AppointmentScheduler opens a
# transaction, which will be nested within RSpec transaction, causing the
# :isolation option to fail as it's only allowed for top-level transactions
RSpec.describe AppointmentScheduler, type: :service, use_transactional_tests: false do
  let(:earliest_allowed) { Time.iso8601('2020-01-01T00:00:00-03:00') }
  let(:latest_allowed) { Time.iso8601('2020-01-07T00:00:00-03:00') }
  let(:patient) { create(:patient, cpf: '29468604004') }
  let(:start_time) { Time.iso8601('2020-01-01T12:00:00-03:00') }
  let(:time) { Time.iso8601('2020-01-01T10:00:00-03:00') }
  let!(:ubs) { create(:ubs, active: true) }

  subject(:scheduler) do
    described_class.new(earliest_allowed: earliest_allowed, latest_allowed: latest_allowed)
  end

  before { travel_to time }
  after { travel_back }

  before do
    allow(patient).to receive(:can_schedule?).and_return(true)
  end

  describe 'when ubs is inactive' do
    before do
      ubs.update!(active: false)
    end

    it 'returns no slots result with no changes to appointments' do
      expect do
        expect(
          scheduler.schedule(patient: patient, ubs_id: nil, from: earliest_allowed, reschedule: false)
        ).to eq([AppointmentScheduler::NO_SLOTS])
      end.not_to(change { Appointment.order(:id).map(&:attributes) })
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

    it 'returns no slots result with no changes to appointments' do
      expect do
        expect(
          scheduler.schedule(patient: patient, ubs_id: nil, from: earliest_allowed, reschedule: false)
        ).to eq([AppointmentScheduler::NO_SLOTS])
      end.not_to(change { Appointment.order(:id).map(&:attributes) })
    end
  end

  describe 'when patient cannot schedule' do
    before do
      allow(patient).to receive(:can_schedule?).and_return(false)
    end

    it 'returns conditions unmet result with no changes to appointments' do
      expect do
        expect(
          scheduler.schedule(patient: patient, ubs_id: nil, from: earliest_allowed, reschedule: false)
        ).to eq([described_class::CONDITIONS_UNMET])
      end.not_to(change { Appointment.order(:id).map(&:attributes) })
    end
  end

  describe 'when start time is past allowed window' do
    let(:past_max_schedule_time_ahead) { Rails.configuration.x.schedule_up_to_days.days.from_now.end_of_day + 1.minute }

    before do
      create(:appointment, start: earliest_allowed + 5.minutes, ubs: ubs, patient_id: nil)
    end

    it 'returns no slots result with no changes to appointments' do
      expect do
        expect(
          scheduler.schedule(patient: patient, ubs_id: nil,
                             from: past_max_schedule_time_ahead,
                             reschedule: false)
        ).to eq([AppointmentScheduler::NO_SLOTS])
      end.not_to(change { Appointment.order(:id).map(&:attributes) })
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
      expect do
        expect(
          scheduler.schedule(patient: patient, ubs_id: nil, from: earliest_allowed, reschedule: false)
        ).to eq([described_class::SUCCESS, Appointment.find_by(patient_id: patient.id)])
      end.to change { patient.appointments.count }.by(1)
    end
  end
end
