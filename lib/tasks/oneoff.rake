namespace :oneoff do
  task inquiry: [:environment] do
    load Rails.root.join('db/seeds/development/6_inquiry.rb')
  end
end
