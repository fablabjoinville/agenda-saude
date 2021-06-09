mlabs = User.new.tap do |user|
  user.name = 'mlabs'
  user.password = 'dontpanic'
  user.password_confirmation = 'dontpanic'
  user.save!
end

mlabs_two = User.new.tap do |user|
  user.name = 'mlabs_two'
  user.password = 'dontpanic'
  user.password_confirmation = 'dontpanic'
  user.save!
end

america = Neighborhood.new.tap do |neighborhood|
  neighborhood.name = 'América'
  neighborhood.save!
end

gloria = Neighborhood.new.tap do |neighborhood|
  neighborhood.name = 'Glória'
  neighborhood.save!
end

Ubs.new.tap do |ubs|
  ubs.name = 'UBSF America'
  ubs.cnes = 13_371
  ubs.users = [mlabs]
  ubs.neighborhoods << america
  ubs.neighborhood = america
  ubs.address = 'Rua Magrathea, 42'
  ubs.phone = '(47) 3443-3443'

  ubs.shift_start = '07:40'
  ubs.break_start = ''
  ubs.break_end = ''
  ubs.shift_end = '22:00'

  ubs.saturday_shift_start = ubs.shift_start
  ubs.saturday_break_start = ubs.break_start
  ubs.saturday_break_end = ubs.break_end
  ubs.saturday_shift_end = ubs.shift_end

  ubs.sunday_shift_start = ubs.shift_start
  ubs.sunday_break_start = ubs.break_start
  ubs.sunday_break_end = ubs.break_end
  ubs.sunday_shift_end = ubs.shift_end

  ubs.slot_interval_minutes = 10
  ubs.appointments_per_time_slot = 50
  ubs.active = true
  ubs.save!
end

Ubs.new.tap do |ubs|
  ubs.name = 'UBSF Gloria'
  ubs.cnes = 13_372
  ubs.users = [mlabs_two]
  ubs.neighborhoods << gloria
  ubs.neighborhood = gloria
  ubs.address = 'Rua dos Bobos, 0'
  ubs.phone = '(47) 3443-3455'

  ubs.shift_start = '9:00'
  ubs.break_start = '12:30'
  ubs.break_end = '13:30'
  ubs.shift_end = '17:00'

  ubs.saturday_shift_start = ubs.shift_start
  ubs.saturday_break_start = ubs.break_start
  ubs.saturday_break_end = ubs.break_end
  ubs.saturday_shift_end = ubs.shift_end

  ubs.sunday_shift_start = ubs.shift_start
  ubs.sunday_break_start = ubs.break_start
  ubs.sunday_break_end = ubs.break_end
  ubs.sunday_shift_end = ubs.shift_end

  ubs.slot_interval_minutes = 30
  ubs.appointments_per_time_slot = 1
  ubs.active = true
  ubs.save!
end

User.new.tap do |user|
  user.name = 'admin'
  user.password = 'dontpanic'
  user.password_confirmation = 'dontpanic'
  user.administrator = true
  user.ubs = Ubs.all
  user.save!
end
