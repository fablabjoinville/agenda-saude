class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:name]

  has_one :ubs, dependent: :restrict_with_exception

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
