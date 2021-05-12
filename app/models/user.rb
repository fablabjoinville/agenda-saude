class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:name]

  has_and_belongs_to_many :ubs

  def admin?
    administrator
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
