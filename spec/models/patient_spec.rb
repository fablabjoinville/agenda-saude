require 'rails_helper'

RSpec.describe Patient, type: :model do
  it 'has valid factory' do
    expect(
      build(:patient)
    ).to be_valid
  end

  it 'has valid birth date' do
    expect(
      Patient.new(birthday: '1999-12-31').tap(&:valid?).errors[:birthday]
    ).not_to be_present
  end

  it 'has validation against bad birth date' do
    expect(
      Patient.new(birthday: '1999-31-31').tap(&:valid?).errors[:birthday]
    ).to be_present

    expect(
      Patient.new(birthday: '1999-12-32').tap(&:valid?).errors[:birthday]
    ).to be_present
  end
end
