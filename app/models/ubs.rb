class Ubs < ApplicationRecord
  validate :times_must_be_ordered
  validates :slot_interval_minutes, inclusion: 1...120

  belongs_to :user
  has_many :appointments, dependent: :destroy

  def shift_start_date(date = Date.today)
    Tod::TimeOfDay.parse(shift_start).on(date).to_time
  end

  def shift_end_date(date = Date.today)
    Tod::TimeOfDay.parse(shift_end).on(date).to_time
  end

  def break_start_date(date = Date.today)
    Tod::TimeOfDay.parse(break_start).on(date).to_time
  end

  def break_end_date(date = Date.today)
    Tod::TimeOfDay.parse(break_end).on(date).to_time
  end

  private

  def times_must_be_ordered
    if shift_start_date > shift_end_date
      errors.add(:shift_start, "não pode ser depois do final do expediente")
    end

    if break_start_date > break_end_date
      errors.add(:break_start, "não pode ser depois do final da pausa")
    end

    if shift_start_date > break_start_date
      errors.add(:shift_start, "não pode ser depois do final do expediente")
    end

    if break_end_date > shift_end_date
      errors.add(:break_end, "não pode ser depois do final do expediente")
    end
  end
end
