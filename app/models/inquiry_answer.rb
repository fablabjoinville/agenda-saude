class InquiryAnswer < ApplicationRecord
  belongs_to :inquiry_question
  has_many :patients_inquiry_answers
  has_many :patients, through: :patients_inquiry_answers

  scope :active, -> { where(active: true) }
  scope :admin_order, -> { order(active: :desc, position: :asc) }
end
