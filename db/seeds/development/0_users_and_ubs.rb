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
  ubs.user = mlabs # Remove me once we replace user with users [jmonteiro]
  ubs.users = [mlabs]
  ubs.neighborhoods << america
  ubs.neighborhood = america.name
  ubs.address = 'Rua Magrathea, 42'
  ubs.phone = '(47) 3443-3443'
  ubs.shift_start = '9:00'
  ubs.break_start = '12:30'
  ubs.break_end = '13:30'
  ubs.shift_end = '17:00'
  ubs.slot_interval_minutes = 20
  ubs.active = true
  ubs.save!
end

Ubs.new.tap do |ubs|
  ubs.name = 'UBSF Gloria'
  ubs.user = mlabs_two # Remove me once we replace user with users [jmonteiro]
  ubs.users = [mlabs_two]
  ubs.neighborhoods << gloria
  ubs.neighborhood = gloria.name
  ubs.address = 'Rua dos Bobos, 0'
  ubs.phone = '(47) 3443-3455'
  ubs.shift_start = '9:00'
  ubs.break_start = '12:30'
  ubs.break_end = '13:30'
  ubs.shift_end = '17:00'
  ubs.slot_interval_minutes = 15
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
