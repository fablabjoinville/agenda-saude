class TimeSlotController < ApplicationController
  def schedule
  end

  def index
    time_slots = Ubs.all.each_with_object({}) do |ubs, memo|
      memo[ubs.identifier] = ubs.available_time_slots(Date.today...3.days.from_now)
    end

    render json: time_slots
  end
end
