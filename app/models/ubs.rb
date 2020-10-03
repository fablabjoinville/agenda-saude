class Ubs < ApplicationRecord
  include TimeSlot

  validate :times_must_be_ordered
  validates :slot_interval_minutes, inclusion: 1...120

  belongs_to :user
  has_many :appointments, dependent: :destroy
  has_and_belongs_to_many :neighborhoods

  scope :active, -> { where(active: true) }

  def identifier
    "#{name} - #{address}."
  end

  def shift_start_date(date = Date.today)
    time_of_day(shift_start, date)
  end

  def shift_end_date(date = Date.today)
    time_of_day(shift_end, date)
  end

  def break_start_date(date = Date.today)
    time_of_day(break_start, date)
  end

  def break_end_date(date = Date.today)
    time_of_day(break_end, date)
  end

  def shift_start_saturday(date = Date.today)
    time_of_day(saturday_shift_start, date)
  end

  def break_start_saturday(date = Date.today)
    time_of_day(saturday_break_start, date)
  end

  def break_end_saturday(date = Date.today)
    time_of_day(saturday_break_end, date)
  end

  def shift_end_saturday(date = Date.today)
    time_of_day(saturday_shift_end, date)
  end

  def slot_interval
    slot_interval_minutes.minutes
  end

  def bedridden_patients
    Patient.where(main_ubs: self).bedridden
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

  def times_must_be_ordered
    if shift_start_date > shift_end_date
      errors.add(:shift_start, "não pode ser depois do final do expediente")
    end

    if break_start_date > break_end_date
      errors.add(:break_start, "não pode ser depois do final da pausa")
    end

    if shift_start_date > break_start_date
      errors.add(:shift_start, "não pode ser depois do início da pausa")
    end

    if break_end_date > shift_end_date
      errors.add(:break_end, "não pode ser depois do final do expediente")
    end


    if shift_start_saturday > shift_end_saturday
      errors.add(:saturday_shift_start, "não pode ser depois do final do expediente")
    end

    if break_start_saturday > break_end_saturday
      errors.add(:saturday_break_start, "não pode ser depois do final da pausa")
    end

    if shift_start_saturday > break_start_saturday
      errors.add(:saturday_shift_start, "não pode ser depois do início da pausa")
    end

    if break_end_saturday > shift_end_saturday
      errors.add(:saturday_break_end, "não pode ser depois do final do expediente")
    end

  end
end
