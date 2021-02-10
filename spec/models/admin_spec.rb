require 'rails_helper'
require 'spec_helper'

RSpec.describe Admin, type: :model do
  it 'password length equal or greater than 6' do
    admin = FactoryBot.create(:admin)
    expect(admin.password.length).to be >= 6
  end

  it 'password equal password_confirmation' do
    admin = FactoryBot.create(:admin)
    expect(admin.password).to eq admin.password_confirmation
  end

  it 'two admins cant have same username' do
    admin1 = Admin.create!(username: 'admin007', password: 'mynameisbond', password: 'mynameisbond')
    admin2 = Admin.new(username: 'admin007', password: 'jamesbond', password: 'jamesbond')
    expect { admin2.save! }.to raise_error
  end
end
