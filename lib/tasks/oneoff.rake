namespace :oneoff do
  desc 'Conditions for production'
  task conditions: [:environment] do
    [
      {
        'name' => 'Pessoas com qualquer comorbidade com 18 anos ou mais',
        'start_at' => Time.zone.parse('2021-01-01 00:00:00'),
        'end_at' => Time.zone.parse('2023-01-01 00:00:00'),
        'min_age' => 18,
        'max_age' => nil,
        'can_register' => true,
        'can_schedule' => false,
        'ubs_ids' => [1, 3, 37, 11, 4, 12, 13, 14, 15, 5, 16, 17, 18, 6, 19, 20, 21, 22, 23, 24, 25, 26, 7, 27, 28, 29, 30, 31,
                      8, 32, 33, 2, 9, 34, 10, 35, 36],
        'group_ids' => [40, 1005, 36, 38, 39, 41, 42, 43, 44, 45, 62, 63, 64, 65, 66, 67, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
                        81, 82, 83, 84, 85, 86, 87, 89, 90, 91, 95, 37]
      },
      {
        'name' => 'Trabalhadores da Educação com 18 anos ou mais',
        'start_at' => Time.zone.parse('2021-01-01 00:00:00'),
        'end_at' => Time.zone.parse('2023-01-01 00:00:00'),
        'min_age' => 18,
        'max_age' => nil,
        'can_register' => true,
        'can_schedule' => false,
        'ubs_ids' => [1, 3, 37, 11, 4, 12, 13, 14, 15, 5, 16, 17, 18, 6, 19, 20, 21, 22, 23, 24, 25, 26, 7, 27, 28, 29, 30, 31,
                      8, 32, 33, 2, 9, 34, 10, 35, 36],
        'group_ids' => [1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022]
      },
      {
        'name' => 'Trabalhadores da Saúde segundo OFÍCIO Nº 234/2021/CGPNI/DEIDT/SVS/MS com 18 anos ou mais',
        'start_at' => Time.zone.parse('2021-01-01 00:00:00'),
        'end_at' => Time.zone.parse('2023-01-01 00:00:00'),
        'min_age' => 18,
        'max_age' => nil,
        'can_register' => true,
        'can_schedule' => true,
        'ubs_ids' => [1, 3, 37, 11, 4, 12, 13, 14, 15, 5, 16, 17, 18, 6, 19, 20, 21, 22, 23, 24, 25, 26, 7, 27, 28, 29, 30, 31,
                      8, 32, 33, 2, 9, 34, 10, 35, 36],
        'group_ids' => [46, 47, 55, 57, 23]
      },
      {
        'name' => 'Pessoas com 60 anos ou mais',
        'start_at' => Time.zone.parse('2021-01-01 00:00:00'),
        'end_at' => Time.zone.parse('2023-01-01 00:00:00'),
        'min_age' => 60,
        'max_age' => nil,
        'can_register' => true,
        'can_schedule' => false,
        'ubs_ids' => [1, 3, 37, 11, 4, 12, 13, 14, 15, 5, 16, 17, 18, 6, 19, 20, 21, 22, 23, 24, 25, 26, 7, 27, 28, 29, 30, 31,
                      8, 32, 33, 2, 9, 34, 10, 35, 36],
        'group_ids' => []
      }
    ].each do |h|
      Condition.find_or_initialize_by(name: h['name']).tap do |c|
        c.attributes = h
        c.save!
      end
    end
  end
end
