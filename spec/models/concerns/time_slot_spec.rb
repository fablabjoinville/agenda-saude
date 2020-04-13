require 'rails_helper'
require 'spec_helper'

RSpec.describe 'TimeSlot' do
  let(:ubs) { create(:ubs) }

  let(:day_range) { (Time.zone.parse('2020-01-01').to_date..Time.zone.parse('2020-01-04').to_date) }
  let(:current_time) { Time.zone.parse('2020-01-01 10:00') }
  let(:today) { day_range.first }

  subject(:slots) { ubs.available_time_slots(day_range, current_time) }

  describe '#available_time_slots' do
    context 'when today is on the range' do
      before { allow(today).to receive(:today?).and_return(true) }

      it 'does not include time slots behind current time' do
        first_slot_start_time = slots[today].first[:slot_start]

        expect(first_slot_start_time).to be >= current_time
      end
    end

    shared_examples_for 'a conflictless list' do
      let(:appointment) { create(:appointment, ubs: ubs) }

      it 'exclude conflicting slots from list' do
        appointment.save!

        expect(slots[today]).not_to include(*conflicting_slots)
      end
    end

    context 'when slot_interval_minutes is reduced' do
      let(:ubs) { create(:ubs, slot_interval_minutes: 10) }

      let(:conflicting_slots) do
        [
          {
            slot_start: Time.zone.parse('2020-01-01 14:00'),
            slot_end: Time.zone.parse('2020-01-01 14:10')
          },
          {
            slot_start: Time.zone.parse('2020-01-01 14:10'),
            slot_end: Time.zone.parse('2020-01-01 14:20')
          }
        ]
      end

      it_behaves_like 'a conflictless list'
    end

    context 'when slot_interval_minutes is increased' do
      let(:ubs) { create(:ubs, slot_interval_minutes: 20) }

      let(:conflicting_slots) do
        [
          {
            slot_start: Time.zone.parse('2020-01-01 14:00'),
            slot_end: Time.zone.parse('2020-01-01 14:20')
          }
        ]
      end

      it_behaves_like 'a conflictless list'
    end

    context 'when shift start is increased' do
      let(:ubs) { create(:ubs, break_end: '14:10') }

      let(:conflicting_slots) do
        [
          {
            slot_start: Time.zone.parse('2020-01-01 14:10'),
            slot_end: Time.zone.parse('2020-01-01 14:25')
          }
        ]
      end

      it_behaves_like 'a conflictless list'
    end

    context 'when shift start is decreased' do
      let(:ubs) { create(:ubs, break_end: '12:50') }

      let(:conflicting_slots) do
        [
          {
            slot_start: Time.zone.parse('2020-01-01 13:50'),
            slot_end: Time.zone.parse('2020-01-01 14:05')
          },
          {
            slot_start: Time.zone.parse('2020-01-01 14:05'),
            slot_end: Time.zone.parse('2020-01-01 14:20')
          }
        ]
      end

      it_behaves_like 'a conflictless list'
    end
  end
end
