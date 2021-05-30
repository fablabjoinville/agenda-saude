class InquiryQuestion < ApplicationRecord
  has_many :inquiry_answers, dependent: :destroy

  enum form_type: { radio: 0, checkbox: 1 }

  scope :active, -> { where(active: true) }
  scope :admin_order, -> { order(active: :desc, position: :asc) }
end
