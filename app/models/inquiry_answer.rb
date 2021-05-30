class InquiryAnswer < ApplicationRecord
  belongs_to :inquiry_question
  has_many :patients_inquiry_answers, dependent: :destroy
  has_many :patients, through: :patients_inquiry_answers, dependent: nil

  scope :active, -> { where(active: true) }
  scope :admin_order, -> { order(active: :desc, position: :asc) }
end
