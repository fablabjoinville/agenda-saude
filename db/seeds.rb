Dir[Rails.root.join('db/seeds/production/*.rb')].each do |file|
  load file
end

if Rails.env.development?
  Dir[Rails.root.join('db/seeds/development/*.rb')].each do |file|
    load file
  end
end
