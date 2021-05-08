class AppointmentsBulk
  include ActiveModel::Attributes
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  extend ActiveModel::Translation

  attr_reader :from, :to
  attr_accessor :active, :ubs_ids

  validates :from, :to, presence: true
  validate do
    errors.add(:ubs_ids, 'precisa ter ao menos uma opção selecionada.') if ubs.empty?
  end

  def from=(value)
    @from = ActiveRecord::Type::Date.new.cast(value)
  end

  def to=(value)
    @to = ActiveRecord::Type::Date.new.cast(value)
  end

  def save
    return false unless valid?

    Ubs.where(id: ubs_ids).all.find_each do |ubs|
      TimeSlotGenerationService.new.call(ubs: ubs, from: from, to: to,
                                         default_attributes: {
                                           active: active
                                         })
    end

    true
  end

  def ubs
    Ubs.where(id: ubs_ids)
  end
end
