class InquiryAnswer < ApplicationRecord
  belongs_to :inquiry_question

  scope :active, -> { where(active: true) }
  scope :admin_order, -> { order(active: :desc, position: :asc) }
end
