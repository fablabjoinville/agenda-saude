require 'rails_helper'

RSpec.describe TimeSlotGenerationService, type: :service do
  let(:subject) do
    TimeSlotGenerationService.new
  end

  let(:from) { Date.new(2021, 1, 3) } # Sunday
  let(:to) { Date.new(2021, 1, 9) } # Saturday

  let(:ubs) do
    create(:ubs,
           sunday_shift_start: '',
           sunday_break_start: '',
           sunday_break_end: '',
           sunday_shift_end: '',
           shift_start: '11:00',
           break_start: '11:50',
           break_end: '13:00',
           shift_end: '14:00',
           saturday_shift_start: '',
           saturday_break_start: '',
           saturday_break_end: '',
           saturday_shift_end: '',
           slot_interval_minutes: 20,
           appointments_per_time_slot: 3)
  end

  it 'create appointments' do
    quantity_to_create = ubs.appointments_per_time_slot *
                         5 * # workdays, skip weekend
                         (
                           2 + # 11:00, 11:20. 11:40 is excluded because it closes at 11:50
                             3 # 13:00, 13:20, 13:40
                         )
    expect do
      subject.call(ubs: ubs, from: from, to: to)
    end.to change { Appointment.count }.by(quantity_to_create)

    expect(Appointment.where(start: from.to_datetime.beginning_of_day..to.to_datetime.end_of_day).count).to eq(quantity_to_create)
    expect(Appointment.where(start: from..to).pick(:active)).to be_truthy
  end

  it 'set default attributes' do
    subject.call(ubs: ubs, from: from, to: to, default_attributes: { active: false })

    expect(Appointment.where(start: from..to).pick(:active)).to be_falsey
  end

  it 'does not create if there are already existing records' do
    subject.call(ubs: ubs, from: from, to: to)

    expect do
      subject.call(ubs: ubs, from: from, to: to)
    end.to change { Appointment.count }.by(0)

    ubs.update! saturday_shift_start: '08:00', saturday_shift_end: '09:00'

    expect do
      subject.call(ubs: ubs, from: from, to: to)
    end.to change { Appointment.count }.by(
      ubs.appointments_per_time_slot *
        3 # 08:00, 08:20, 08:40
    )
  end

  it 'generates a last run report' do
    last_run_report = subject.call(ubs: ubs, from: from, to: to)
    zone = ActiveSupport::TimeZone['Brasilia']

    expect(last_run_report).to eq(
      [
        [],
        [{ zone.parse('2021-01-04 11:00:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-04 11:20:00') => { created: 3, taken: 0 } },
         { zone.parse('2021-01-04 13:00:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-04 13:20:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-04 13:40:00') => { created: 3, taken: 0 } }],
        [{ zone.parse('2021-01-05 11:00:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-05 11:20:00') => { created: 3, taken: 0 } },
         { zone.parse('2021-01-05 13:00:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-05 13:20:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-05 13:40:00') => { created: 3, taken: 0 } }],
        [{ zone.parse('2021-01-06 11:00:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-06 11:20:00') => { created: 3, taken: 0 } },
         { zone.parse('2021-01-06 13:00:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-06 13:20:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-06 13:40:00') => { created: 3, taken: 0 } }],
        [{ zone.parse('2021-01-07 11:00:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-07 11:20:00') => { created: 3, taken: 0 } },
         { zone.parse('2021-01-07 13:00:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-07 13:20:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-07 13:40:00') => { created: 3, taken: 0 } }],
        [{ zone.parse('2021-01-08 11:00:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-08 11:20:00') => { created: 3, taken: 0 } },
         { zone.parse('2021-01-08 13:00:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-08 13:20:00') => { created: 3, taken: 0 },
           zone.parse('2021-01-08 13:40:00') => { created: 3, taken: 0 } }],
        []
      ]
    )
  end

  it 'generates for only a single day' do
    quantity_to_create = ubs.appointments_per_time_slot *
                         (
                           2 + # 11:00, 11:20. 11:40 is excluded because it closes at 11:50
                             3 # 13:00, 13:20, 13:40
                         )
    expect do
      subject.call(ubs: ubs, from: Date.new(2021, 1, 5), to: Date.new(2021, 1, 5)) # Tuesday
    end.to change { Appointment.count }.by(quantity_to_create)
  end
end
