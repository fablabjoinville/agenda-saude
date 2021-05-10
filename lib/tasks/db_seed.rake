namespace :db do
  namespace :seed do
    desc 'Development seeds'
    task development: [:environment] do
      Dir[Rails.root.join('db/seeds/development/*.rb')].each do |file|
        load file
      end
    end
  end
end
