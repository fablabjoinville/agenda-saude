TimeSlotGenerationService.new(create_slot: ->(attrs) { Appointment.create(attrs) })
                         .execute(
                           TimeSlotGenerationService::Options.new(
                             ubs_id: Ubs.first.id,
                             start_date: 15.minutes.from_now.to_datetime,
                             end_date: 4.days.from_now.to_datetime,
                             weekdays: [*0..6],
                             excluded_dates: [],
                             windows: [{ start_time: '7:00', end_time: '23:59', slots: 2 }],
                             slot_interval_minutes: 30
                           )
                         )

TimeSlotGenerationService.new(create_slot: ->(attrs) { Appointment.create(attrs) })
                         .execute(
                           TimeSlotGenerationService::Options.new(
                             ubs_id: Ubs.second.id,
                             start_date: 15.minutes.from_now.to_datetime,
                             end_date: 4.days.from_now.to_datetime,
                             weekdays: [*0..6],
                             excluded_dates: [],
                             windows: [{ start_time: '12:00', end_time: '19:00', slots: 2 }],
                             slot_interval_minutes: 20
                           )
                         )
