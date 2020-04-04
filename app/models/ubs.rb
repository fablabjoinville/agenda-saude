class Ubs < ApplicationRecord
  validate :times_must_be_ordered
  belongs_to :user

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
    if shift_start > shift_end
      errors.add(:shift_start, "can't be higher than shift_end")
    end

    if break_start > break_end
      errors.add(:break_start, "can't be higher than break_end")
    end

    if shift_start > break_start
      errors.add(:shift_start, "can't be higher than break_start")
    end

    if break_end > shift_end
      errors.add(:break_end, "can't be higher than shift_end")
    end
  end
end
