require 'rails_helper'

RSpec.describe SchedulingCondition, type: :model do
  subject { build(:scheduling_condition) }

  it 'is enabled' do
    expect(subject).to be_enabled
  end

  it 'is active' do
    expect(subject).to be_active
  end

  describe 'condition for 18 or older' do
    subject { build(:scheduling_condition, min_age: 18) }

    it 'allows a patient' do
      patient = double
      expect(patient).to receive(:age).and_return(21)

      expect(subject.allowed?(patient)).to be_truthy
    end

    it 'forbids a patient' do
      patient = double
      expect(patient).to receive(:age).and_return(16)

      expect(subject.allowed?(patient)).to be_falsey
    end
  end

  describe 'condition for a group' do
    let(:group) { create(:group) }
    subject { build(:scheduling_condition, min_age: nil, group_ids: [group.id]) }

    it 'allows a patient' do
      patient = double
      expect(patient).to receive(:group_ids).and_return([group.id])

      expect(subject.allowed?(patient)).to be_truthy
    end

    it 'forbids a patient' do
      patient = double
      expect(patient).to receive(:group_ids).and_return([])

      expect(subject.allowed?(patient)).to be_falsey
    end
  end
end
