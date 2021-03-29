class HomeController < ApplicationController
  def index
    return redirect_to index_bedridden_path if current_patient&.bedridden?
    return redirect_to home_community_appointments_path if current_patient
    return redirect_to operator_appointments_path if current_user

    from = Rails.configuration.x.schedule_from_hours.hours.from_now
    to = Rails.configuration.x.schedule_up_to_days.days.from_now.end_of_day
    @available_appointments_any = Appointment.active_ubs
                                             .active
                                             .not_scheduled
                                             .open
                                             .where(start: from..to)
                                             .any? # TODO: change it to count after we have caching
  end
end
