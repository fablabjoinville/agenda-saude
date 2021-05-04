# rubocop:disable Layout/LineLength

[
  { id: 1, name: 'CoronaVac', formal_name: 'Sinovac COVID-19 CoronaVac',
    second_dose_after_in_days: 4 * 7, legacy_name: 'coronavac' },
  { id: 2, name: 'AstraZeneca', formal_name: 'Oxford–AstraZeneca COVID-19 ChAdOx1 (AZD1222)',
    second_dose_after_in_days: 13 * 7, legacy_name: 'astra_zeneca' }
].each do |h|
  Vaccine.find_or_initialize_by(id: h[:id]).tap { |r| r.update!(h) }
end

[
  { id: 998, name: 'Não me encaixo em nenhum dos grupos listados', position: 0 },
  { id: 23, name: 'Trabalhador(a) da Saúde', position: 1 },
  { id: 24, name: 'Trabalhador(a) da Educação', position: 2 },
  { id: 25, name: 'Trabalhador(a) das Forças de Seguranças e Salvamento', position: 3 },
  { id: 26, name: 'Forças Armadas', position: 4 },
  { id: 28, name: 'Trabalhador(a) de transporte coletivo rodoviário de passageiros urbano e de longoprazo', position: 5 },
  { id: 29, name: 'Trabalhador(a) de transporte metroviário e ferroviário', position: 6 },
  { id: 30, name: 'Trabalhador(a) do transporte aéreo', position: 7 },
  { id: 31, name: 'Trabalhador(a) do transporte aquaviário', position: 8 },
  { id: 32, name: 'Caminhoneiro(a)', position: 9 },
  { id: 33, name: 'Trabalhador(a) portuário', position: 10 },
  { id: 34, name: 'Trabalhador(a) da construção civil', position: 11 },
  { id: 35, name: 'Pessoa com deficiência permanente grave', position: 12 },
  { id: 60, name: 'Trabalhadores do sistema funerário', position: 13 },
  { id: 61, name: 'Trabalhador da Indústria em Geral', position: 14 },

  # Comorbidity:

  { id: 999, name: 'Não possuo nenhuma das comorbidades ou a que tenho, não está na lista', context: 1, position: 0 },
  { id: 41, name: 'Doença renal crônica', context: 1, position: 1 },
  { id: 85, name: 'Doença renal crônica em terapia de substituição renal (diálise)', context: 1, parent_group_id: 41, position: 0 },
  { id: 86, name: 'Doença renal crônica estágio 3 ou mais', context: 1, parent_group_id: 41, position: 1 },
  { id: 87, name: 'Síndrome Nefrótica', context: 1, parent_group_id: 41, position: 2 },

  { id: 36, name: 'Diabetes mellitus', context: 1, position: 2 },

  { id: 37, name: 'Pneumopatias graves', context: 1, position: 3 },
  { id: 62, name: 'Doença Pulmonar Obstrutiva Crônica', context: 1, parent_group_id: 37, position: 0 },
  { id: 63, name: 'Fibrose Cística', context: 1, parent_group_id: 37, position: 1 },
  { id: 64, name: 'Fibroses Pulmonares', context: 1, parent_group_id: 37, position: 2 },
  { id: 65, name: 'Pneumoconioses', context: 1, parent_group_id: 37, position: 3 },
  { id: 66, name: 'Displasia Broncopulmonar', context: 1, parent_group_id: 37, position: 4 },
  { id: 67, name: 'Asma Grave (uso recorrente de corticoides sistêmicos, internação prévia por crise asmática)', context: 1, parent_group_id: 37, position: 5 },

  { id: 38, name: 'Hipertensão', context: 1, position: 4 },
  { id: 68, name: 'Hipertensão Arterial Resistente (HAR)', context: 1, parent_group_id: 38, position: 0 },
  { id: 69, name: 'Hipertensão Arterial estágio 3', context: 1, parent_group_id: 38, position: 1 },
  { id: 70, name: 'Hipertensão Arterial estágios 1 e 2 com LOA e/ou comorbidade', context: 1, parent_group_id: 38, position: 2 },

  { id: 39, name: 'Doenças cardiovasculares', context: 1, position: 5 },
  { id: 71, name: 'Insuficiência Cardíaca', context: 1, parent_group_id: 39, position: 0 },
  { id: 72, name: 'Cor-pulmonale e Hipertensão Pulmonar', context: 1, parent_group_id: 39, position: 1 },
  { id: 73, name: 'Cardiopatia Hipertensiva', context: 1, parent_group_id: 39, position: 2 },
  { id: 74, name: 'Síndromes Coronarianas', context: 1, parent_group_id: 39, position: 3 },
  { id: 75, name: 'Valvopatias', context: 1, parent_group_id: 39, position: 4 },
  { id: 76, name: 'Miocardiopatias e Pericardiopatias', context: 1, parent_group_id: 39, position: 5 },
  { id: 77, name: 'Doenças da Aorta, dos grandes vasos e fístulas arteriovenosas', context: 1, parent_group_id: 39, position: 6 },
  { id: 78, name: 'Arritmias Cardíacas', context: 1, parent_group_id: 39, position: 7 },
  { id: 79, name: 'Cardiopatia Congênita no adulto', context: 1, parent_group_id: 39, position: 8 },
  { id: 80, name: 'Próteses valvares e Dispositivos cardíacos implantados', context: 1, parent_group_id: 39, position: 9 },

  { id: 40, name: 'Doença cerebrovascular', context: 1, position: 6 },
  { id: 81, name: 'Acidente Vascular Cerebral Isquêmico (AVC)', context: 1, parent_group_id: 40, position: 0 },
  { id: 82, name: 'Acidente Vascular Cerebral Hemorrágico', context: 1, parent_group_id: 40, position: 1 },
  { id: 83, name: 'Ataque Isquêmico Transitório', context: 1, parent_group_id: 40, position: 2 },
  { id: 84, name: 'Demência Vascular', context: 1, parent_group_id: 40, position: 3 },

  { id: 42, name: 'Imunossuprimidos', context: 1, position: 7 },
  { id: 88, name: 'Transplantados de órgãos sólidos ou de medula óssea', context: 1, parent_group_id: 42, position: 0 },
  { id: 89, name: 'Pessoas vivendo com HIV e CD4 < 350 células/mm³', context: 1, parent_group_id: 42, position: 1 },
  { id: 90, name: 'Doenças reumáticas imunomediadas sistêmicas em atividade e em uso de dose de prednisona equivalente >10mg/dia ou recebendo pulsoterapia com corticóide e/ou ciclofosfamida', context: 1, parent_group_id: 42, position: 2 },
  { id: 91, name: 'Demais indivíduos em uso de imunossupressores ou com imunodeficiências primárias', context: 1, parent_group_id: 42, position: 3 },

  { id: 92, name: 'Gestantes e puérperas com comorbidades', context: 1, position: 8 },
  { id: 93, name: 'Gestantes e puérperas sem comorbidades', context: 1, position: 9 },
  { id: 94, name: 'Pessoas com deficiências permanentes cadastradas no Programa de Benefício de Prestação Continuada (BPC)', context: 1, position: 10 },
  { id: 95, name: 'Cirrose hepática - (Child-Pugh A, B ou C)', context: 1, position: 11 },
  { id: 43, name: 'Anemia falciforme', context: 1, position: 12 },
  { id: 44, name: 'Obesidade mórbida (IMC >=40)', context: 1, position: 13 },
  { id: 45, name: 'Síndrome de down', context: 1, position: 14 },

  # Deactivated:

  { id: 27, name: 'Portador(a) de comorbidade', active: false },
  { id: 53, name: 'Pessoa com 60 anos ou mais', active: false },
  { id: 58, name: 'Pessoa com 90 anos ou mais', active: false },
  { id: 46, name: 'Área da assistência/tratamento', active: false, parent_group_id: 23 },
  { id: 47, name: 'Administrativo e outros setores', active: false, parent_group_id: 23 },
  { id: 55, name: 'Estagiário da área da Saúde', active: false, parent_group_id: 23 },
  { id: 57, name: 'Atua em Hospital', active: false, parent_group_id: 23 },
  { id: 48, name: 'Professor(a) em sala de aula', active: false, parent_group_id: 24 },
  { id: 49, name: 'Administrativo e outros setores', active: false, parent_group_id: 24 },
  { id: 50, name: 'Oficial em atividade de linha de frente', active: false, parent_group_id: 25 },
  { id: 51, name: 'Oficial em atividade administrativa', active: false, parent_group_id: 25 },
  { id: 52, name: 'Outra(s)', active: false, parent_group_id: 27 }
].each do |h|
  Group.find_or_initialize_by(id: h[:id]).tap do |group|
    group.attributes = { parent_group_id: nil, context: 0, active: true }.merge(h)
    group.save!
  end
end
