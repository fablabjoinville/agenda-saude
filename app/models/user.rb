class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:name]

  has_one :ubs, dependent: :restrict_with_exception
  # has_and_belongs_to_many :ubs # For future use [jmonteiro]

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
