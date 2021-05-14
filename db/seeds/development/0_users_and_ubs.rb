mlabs = User.find_or_initialize_by(name: 'mlabs').tap do |user|
  user.password = 'dontpanic'
  user.password_confirmation = 'dontpanic'
  user.save!
end

mlabs_two = User.find_or_initialize_by(name: 'mlabs_two').tap do |user|
  user.password = 'dontpanic'
  user.password_confirmation = 'dontpanic'
  user.save!
end
