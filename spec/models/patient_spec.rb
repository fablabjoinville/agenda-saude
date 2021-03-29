require 'rails_helper'

RSpec.describe Patient, type: :model do
  it 'has valid factory' do
    expect(
      build(:patient)
    ).to be_valid
  end
end
