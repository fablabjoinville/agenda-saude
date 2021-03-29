require 'rails_helper'

RSpec.describe Appointment, type: :model do
  it 'has valid factory' do
    expect(
      build(:appointment)
    ).to be_valid
  end
end
