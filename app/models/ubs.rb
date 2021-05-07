class Ubs < ApplicationRecord
  validate :times_must_be_ordered
  validates :slot_interval_minutes, inclusion: 1...120
  validates :appointments_per_time_slot, numericality: { greater_than: 0 }

  belongs_to :user
  has_and_belongs_to_many :neighborhoods
  has_and_belongs_to_many :users # For future use [jmonteiro]
  has_many :appointments, dependent: :destroy

  scope :active, -> { where(active: true) }

  def identifier
    "#{name} — #{full_address}"
  end

  def full_address
    "#{address} (#{neighborhood})"
  end

  def shift_start_date(date = Time.zone.today)
    time_of_day(shift_start, date)
  end

  def shift_end_date(date = Time.zone.today)
    time_of_day(shift_end, date)
  end

  def break_start_date(date = Time.zone.today)
    time_of_day(break_start, date)
  end

  def break_end_date(date = Time.zone.today)
    time_of_day(break_end, date)
  end

  def shift_start_saturday(date = Time.zone.today)
    time_of_day(saturday_shift_start, date)
  end

  def break_start_saturday(date = Time.zone.today)
    time_of_day(saturday_break_start, date)
  end

  def break_end_saturday(date = Time.zone.today)
    time_of_day(saturday_break_end, date)
  end

  def shift_end_saturday(date = Time.zone.today)
    time_of_day(saturday_shift_end, date)
  end

  def slot_interval
    slot_interval_minutes.minutes
  end

  def time_of_day(time, date)
    Tod::TimeOfDay.parse(time).on(date).in_time_zone
  end

  private

  def morning_shift(day)
    shift_start_date(day).to_i...break_start_date(day).to_i
  end

  def afternoon_shift(day)
    break_end_date(day).to_i...shift_end_date(day).to_i
  end

  def morning_saturday(day)
    shift_start_saturday(day).to_i...break_start_saturday(day).to_i
  end

  def afternoon_saturday(day)
    break_end_saturday(day).to_i...shift_end_saturday(day).to_i
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def times_must_be_ordered
    errors.add(:shift_start, 'não pode ser depois do final do expediente') if shift_start_date > shift_end_date

    errors.add(:break_start, 'não pode ser depois do final da pausa') if break_start_date > break_end_date

    errors.add(:shift_start, 'não pode ser depois do início da pausa') if shift_start_date > break_start_date

    errors.add(:break_end, 'não pode ser depois do final do expediente') if break_end_date > shift_end_date

    errors.add(:saturday_shift_start, 'não pode ser depois do final do expediente') if shift_start_saturday > shift_end_saturday

    errors.add(:saturday_break_start, 'não pode ser depois do final da pausa') if break_start_saturday > break_end_saturday

    errors.add(:saturday_shift_start, 'não pode ser depois do início da pausa') if shift_start_saturday > break_start_saturday

    errors.add(:saturday_break_end, 'não pode ser depois do final do expediente') if break_end_saturday > shift_end_saturday
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
