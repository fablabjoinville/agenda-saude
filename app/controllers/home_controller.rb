class HomeController < ApplicationController
  # rubocop:disable Metrics/AbcSize
  def index
    return redirect_to home_community_appointments_path if current_patient
    return redirect_to operator_ubs_index_path if current_user

    from = Rails.configuration.x.schedule_from_hours.hours.from_now
    to = Rails.configuration.x.schedule_up_to_days.days.from_now.end_of_day
    @appointments_any = Appointment.available_doses
                                   .where(start: from..to)
                                   .any? # TODO: change it to count after we have caching

    @home = Page.find_by!(path: :home).html
  end
  # rubocop:enable Metrics/AbcSize
end
