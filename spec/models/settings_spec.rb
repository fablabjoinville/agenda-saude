require 'rails_helper'

RSpec.describe Settings do
  it 'can read configuration file' do
    expect(
      Settings[:city_name]
    ).to eq('Joinville')
  end
end
