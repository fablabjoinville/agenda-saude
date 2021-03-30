require 'rails_helper'

RSpec.describe Ubs, type: :model do
  it 'has valid factory' do
    expect(
      build(:ubs)
    ).to be_valid
  end
end
