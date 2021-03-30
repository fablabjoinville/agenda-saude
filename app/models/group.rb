class Group < ApplicationRecord
  has_and_belongs_to_many :patients

  belongs_to :parent_group, optional: true, class_name: 'Group'
  has_many :children, class_name: 'Group', foreign_key: :parent_group_id, dependent: :destroy, inverse_of: :parent_group

  scope :root, -> { where(parent_group_id: nil) }

  def health_worker?
    name == 'Trabalhador(a) da Saúde'
  end

  def specific_comorbidity?
    name == 'Outra(s)'
  end
end
