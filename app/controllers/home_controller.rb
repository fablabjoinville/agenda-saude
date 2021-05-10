class HomeController < ApplicationController
  CACHE_EXPIRES_IN = 30.seconds

  def index
    return redirect_to home_community_appointments_path if current_patient
    return redirect_to operator_ubs_index_path if current_user

    @can_register_condition_names = Rails.cache.fetch('home/condition_names', expires_in: CACHE_EXPIRES_IN) do
      condition_names
    end
    @can_schedule_conditions = Rails.cache.fetch('home/schedule_conditions', expires_in: CACHE_EXPIRES_IN) do
      schedule_conditions
    end

    @appointments_any = @can_schedule_conditions.pluck(:doses_count).inject(:+)&.positive?

    @home_page = Page.find_by!(path: :home)
  end

  protected

  def condition_names
    Condition.active.can_register.order(:name).pluck(:name)
  end

  def schedule_conditions
    Condition.active.can_schedule.order(:name).includes(:ubs).map do |c|
      {
        name: c.name,
        ubs_names: c.ubs_ids.count == ubs_count ? 'todas unidades' : c.ubs.order(:name).pluck(:name).join(', '),
        doses_count: Appointment.available_doses
                                .where(start: from..to, ubs_id: c.ubs_ids)
                                .count
      }
    end
  end

  def ubs_count
    @ubs_count ||= Ubs.count
  end

  def from
    @from ||= Rails.configuration.x.schedule_from_hours.hours.from_now
  end

  def to
    @to ||= Rails.configuration.x.schedule_up_to_days.days.from_now.end_of_day
  end
end
