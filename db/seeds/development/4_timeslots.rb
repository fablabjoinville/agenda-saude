Ubs.all.each do |ubs|
  TimeSlotGenerationService.new.call(ubs: ubs, from: Time.zone.today, to: 4.days.from_now.to_date)
end
