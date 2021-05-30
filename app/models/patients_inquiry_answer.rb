class PatientsInquiryAnswer < ApplicationRecord
  belongs_to :patient
  belongs_to :inquiry_answer
end
