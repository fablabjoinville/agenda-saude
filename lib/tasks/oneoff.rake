namespace :oneoff do
  task inquiry: [:environment] do
    load Rails.root.join('db/seeds/development/5_inquiry.rb')
  end
end
