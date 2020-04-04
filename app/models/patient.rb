class Patient < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :rememberable

  def email_required?
    false
  end

  def email_changed?
    false
  end

  has_many :appointments, dependent: :destroy

  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true, cpf_format: { strict: true }
  validates :mother_name, presence: true
  validates :birth_date, presence: true
  validates :phone, presence: true
  validates :neighborhood, presence: true
end
