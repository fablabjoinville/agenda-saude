require 'rails_helper'

RSpec.describe TimeSlotGenerationService, type: :service do
  let(:all_generated_attributes) { [] }
  let(:create_slot) do
    lambda { |attrs| all_generated_attributes << attrs }
  end
  let(:service) do
    TimeSlotGenerationService.new(
      create_slot: create_slot
    )
  end
  let(:ubs) do
    OpenStruct.new(
      id: 1,
      shift_start: '7:30',
      break_start: '12:00',
      break_end: '13:00',
      shift_end: '18:00',
      slot_interval_minutes: 20,
      appointments_per_time_slot: 19
    )
  end
  let(:options) do
    TimeSlotGenerationService::Options.new(
      start_date: DateTime.new(2021, 1, 1),
      end_date: DateTime.new(2021, 2, 15),
      ubs_id: ubs.id,
      windows: [
        { start_time: '7:30', end_time: '12:00', slots: 19 },
        { start_time: '13:00', end_time: '18:00', slots: 15 }
      ],
      slot_interval_minutes: 20,
      excluded_dates: [Date.new(2021, 1, 4)],
      weekdays: [*1..5], # 0 = Sunday
    )
  end
  let(:expected_time_slot_attributes_file) do
    File.join(
      File.dirname(__FILE__),
      'expected_time_slot_attributes.json'
    )
  end
  let(:expected_time_slot_attributes_json) do
    File.read(expected_time_slot_attributes_file)
  end
  let(:update_snapshot?) { false }

  before do
    service.execute(options)

    if update_snapshot?
      File.write(
        expected_time_slot_attributes_file,
        all_generated_attributes.to_json
      )
    end
  end

  it 'produces output matching the expected attributes' do
    expect_equal_or_dump_actual_value(
      expected_time_slot_attributes_json,
      all_generated_attributes.to_json
    )
  end

  it 'does not create time slots for weekdays out of range' do
    weekday_excluded_dates = [
      Date.new(2021, 1, 2), # Saturday
      Date.new(2021, 1, 3), # Sunday
      Date.new(2021, 1, 9), # Saturday
      Date.new(2021, 1, 10), # Sunday
    ]
    unexpected_date_found = all_generated_attributes.any? do |slot_attributes|
      slot_attributes[:start].to_date.in?(weekday_excluded_dates)
    end
    expect(unexpected_date_found).to be(false)
  end

  it 'does not create time slots for excluded dates' do
    unexpected_date_found = all_generated_attributes.any? do |slot_attributes|
      slot_attributes[:start].to_date.in?(options.excluded_dates)
    end
    expect(unexpected_date_found).to be(false)
  end

  it 'does not create time slots which exceed time windows' do
    random_time_slot = all_generated_attributes.sample
    random_day_time_slots = all_generated_attributes.select do |slot_attributes|
      slot_attributes[:start].to_date == random_time_slot[:start].to_date
    end

    # Generating an array with timestamps of every minute
    # within the windows is easier than using date ranges
    # because it's not necessary to iterate every window
    time_windows = [
      (7.hours + 30.minutes)..12.hours,
      13.hours..18.hours
    ]
    allowed_timestamps = time_windows.flat_map do |window|
      base_date = random_time_slot[:start].at_beginning_of_day
      ((base_date + window.begin).to_i..(base_date + window.end).to_i).step(1.minute).to_a
    end

    unexpected_time_slot_found = random_day_time_slots.any? do |slot_attributes|
      allowed_timestamps.exclude?(slot_attributes[:start].to_i) ||
        allowed_timestamps.exclude?(slot_attributes[:end].to_i)
    end

    expect(unexpected_time_slot_found).to be(false)
  end

  def expect_equal_or_dump_actual_value(expected, actual)
    expect(expected).to eq(actual), lambda {
      dump_attributes_and_build_failure_message(actual)
    }
  end

  #
  # Serializes generated attributes to json and
  # writes to a file for diffing with expected attributes
  #
  def dump_attributes_and_build_failure_message(all_generated_attributes_json)
    generated_attributes_file = Rails.root.join(
      "tmp",
      "generated_attributes_file.json"
    )

    File.write(generated_attributes_file, all_generated_attributes_json)

    "Generated attributes do not match expected attributes.\n" \
      "Compare #{generated_attributes_file} and " \
        "#{expected_time_slot_attributes_file} for further checks"
  end
end
