[
  {
    name: 'Pessoas com qualquer comorbidade com 18 anos ou mais',
    start_at: Time.zone.parse('2021-01-01 00:00:00'),
    end_at: 1.year.from_now,
    min_age: 18,
    can_register: true,
    can_schedule: false,
    ubs_ids: Ubs.all.pluck(:id)
  },
  {
    name: 'Trabalhadores da Educação com 18 anos ou mais',
    start_at: Time.zone.parse('2021-01-01 00:00:00'),
    end_at: 1.year.from_now,
    min_age: 18,
    can_register: true,
    can_schedule: false,
    ubs_ids: Ubs.all.pluck(:id)
  },
  {
    name: 'Trabalhadores da Saúde segundo OFÍCIO Nº 234/2021/CGPNI/DEIDT/SVS/MS com 18 anos ou mais',
    start_at: Time.zone.parse('2021-01-01 00:00:00'),
    end_at: 1.year.from_now,
    min_age: 18,
    can_register: true,
    can_schedule: false,
    ubs_ids: Ubs.all.pluck(:id)
  },
  {
    name: 'Pessoas com 60 anos ou mais',
    start_at: Time.zone.parse('2021-01-01 00:00:00'),
    end_at: 1.year.from_now,
    min_age: 60,
    can_register: true,
    can_schedule: true,
    ubs_ids: Ubs.all.pluck(:id)
  }
].each do |h|
  Condition.find_or_initialize_by(name: h[:name]).tap do |condition|
    condition.attributes = h
    condition.save!
  end
end
