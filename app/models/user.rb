class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :authentication_keys => [:name]

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
