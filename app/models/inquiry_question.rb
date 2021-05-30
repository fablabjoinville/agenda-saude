class InquiryQuestion < ApplicationRecord
  has_many :inquiry_answers, dependent: :destroy

  enum form_type: { radio_button: 0, check_box: 1 }

  scope :active, -> { where(active: true) }
  scope :admin_order, -> { order(active: :desc, position: :asc) }
end
