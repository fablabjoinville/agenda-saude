class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
  :recoverable, :rememberable, :validatable, :authentication_keys => [:username]

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
