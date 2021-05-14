UbsCreatorService.new(ubs_data_basedir: ENV.fetch('UBS_DATA_BASEDIR', 'scripts/data/joinville')).call

# WARNING: MUDAR SENHA EM PRODUCAO
User.find_or_initialize_by(name: 'admin').tap do |user|
  user.password = 'dontpanic'
  user.password_confirmation = 'dontpanic'
  user.administrator = true
  user.save!

  user.ubs = Ubs.all
end
