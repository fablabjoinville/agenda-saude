class SchedulingCondition < ApplicationRecord
  has_and_belongs_to_many :groups

  validates :name, :start_at, presence: true
  validates :min_age, :max_age, numericality: { only_integer: true, allow_nil: true,
                                                greater_than_or_equal_to: 0, less_than_or_equal_to: 120 }

  scope :enabled, -> { where(active: true).where('start_at < NOW()') }

  def allowed?(patient)
    allowed_min_age?(patient) && allowed_max_age?(patient) && allowed_groups?(patient)

    # Notes:
    # - Não incluir nenhum com active=false
    # - Pegar IDs de production para ter certeza
    # - Quando aditionar um grupo com vários filhos, incluir todos os filhos
    # - Quando quiser só adicionar uma subcondição espeçifica, só adicione o item (sem incluir o ID do grupo pai)
    group_ids = [38, 68, 69, 70, 39, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 42, 88, 89, 90, 91]

    # age check && check if there's an intersection between arrays
    age >= 18 && (group_ids & patient.group_ids).any?
  end

  def allowed_min_age?(patient)
    min_age.blank? ||
      patient.age >= min_age
  end

  def allowed_max_age?(patient)
    max_age.blank? ||
      patient.age <= max_age
  end

  def allowed_groups?(patient)
    group_ids.empty? ||
      (group_ids & patient.group_ids).any?
  end
end
