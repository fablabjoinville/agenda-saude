class Ubs < ApplicationRecord
  validates :neighborhood_id, presence: true
  validates :slot_interval_minutes, inclusion: 1...120
  validates :appointments_per_time_slot, numericality: { greater_than: 0 }

  validates :shift_start, time_of_day: true,
                          presence: { if: proc { |u| u.shift_end.present? || u.break_start.present? } }
  validates :shift_end, time_of_day: true, presence: { if: proc { |u| u.shift_start.present? } }
  validates :break_start, time_of_day: true, presence: { if: proc { |u| u.break_end.present? } }
  validates :break_end, time_of_day: true, presence: { if: proc { |u| u.break_start.present? } }

  validates :saturday_shift_start, time_of_day: true,
                                   presence: { if: proc { |u| u.saturday_shift_end.present? || u.saturday_break_start.present? } }
  validates :saturday_shift_end, time_of_day: true, presence: { if: proc { |u| u.saturday_shift_start.present? } }
  validates :saturday_break_start, time_of_day: true, presence: { if: proc { |u| u.saturday_break_end.present? } }
  validates :saturday_break_end, time_of_day: true, presence: { if: proc { |u| u.saturday_break_start.present? } }

  validates :sunday_shift_start, time_of_day: true,
                                 presence: { if: proc { |u| u.sunday_shift_end.present? || u.sunday_break_start.present? } }
  validates :sunday_shift_end, time_of_day: true, presence: { if: proc { |u| u.sunday_shift_start.present? } }
  validates :sunday_break_start, time_of_day: true, presence: { if: proc { |u| u.sunday_break_end.present? } }
  validates :sunday_break_end, time_of_day: true, presence: { if: proc { |u| u.sunday_break_start.present? } }

  belongs_to :neighborhood
  has_and_belongs_to_many :neighborhoods
  has_and_belongs_to_many :users
  has_many :appointments, dependent: :destroy

  scope :active, -> { where(active: true) }

  def identifier
    "#{name} — #{full_address}"
  end

  def full_address
    "#{address} (#{neighborhood.name})"
  end

  def time_windows(weekday)
    case weekday.to_i
    when 0
      sunday_time_windows
    when 6
      saturday_time_windows
    else
      workday_time_windows
    end
  end

  def sunday_time_windows
    return [] if sunday_shift_start.blank?

    return [[Tod::TimeOfDay.parse(sunday_shift_start), Tod::TimeOfDay.parse(sunday_shift_end)]] if sunday_break_start.blank?

    [[Tod::TimeOfDay.parse(sunday_shift_start), Tod::TimeOfDay.parse(sunday_break_start)],
     [Tod::TimeOfDay.parse(sunday_break_end), Tod::TimeOfDay.parse(sunday_shift_end)]]
  end

  def workday_time_windows
    return [] if shift_start.blank?

    return [[Tod::TimeOfDay.parse(shift_start), Tod::TimeOfDay.parse(shift_end)]] if break_start.blank?

    [[Tod::TimeOfDay.parse(shift_start), Tod::TimeOfDay.parse(break_start)],
     [Tod::TimeOfDay.parse(break_end), Tod::TimeOfDay.parse(shift_end)]]
  end

  def saturday_time_windows
    return [] if saturday_shift_start.blank?

    if saturday_break_start.blank?
      return [[Tod::TimeOfDay.parse(saturday_shift_start),
               Tod::TimeOfDay.parse(saturday_shift_end)]]
    end

    [[Tod::TimeOfDay.parse(saturday_shift_start), Tod::TimeOfDay.parse(saturday_break_start)],
     [Tod::TimeOfDay.parse(saturday_break_end), Tod::TimeOfDay.parse(saturday_shift_end)]]
  end
end
