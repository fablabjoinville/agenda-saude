from = 15.minutes.from_now.to_datetime
to = 7.days.from_now.to_datetime

Ubs.all.each do |ubs|
  TimeSlotGenerationService.new.call(ubs: ubs, from: from, to: to)
end
