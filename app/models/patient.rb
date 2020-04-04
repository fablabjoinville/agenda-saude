class Patient < ApplicationRecord
  has_many :appointments, dependent: :destroy
end
