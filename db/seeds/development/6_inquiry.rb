# rubocop:disable Layout/LineLength
[
  {
    text: 'Qual seu sexo biológico?',
    form_type: :radio,

    answers: %w[
      Masculino
      Feminino
    ]
  },
  {
    text: 'Você tem alguma doença?',
    form_type: :checkbox,

    answers: [
      'Hipertensão',
      'Diabetes',
      'Utiliza insulina',
      'Doença na tireoide',
      'Doença no coração',
      'Arritmia no coração',
      'Utiliza varfarina',
      'Doença nos rins',
      'Precisa de hemodiálise',
      'Câncer',
      'Já teve AVC',
      'Já teve infarto',
      'Outras doenças'
    ]
  },
  {
    text: 'Você tem plano de saúde?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim',
      'Sim, mas também utiliza o SUS para consultas ou exames'
    ]
  },
  {
    text: 'Nos últimos 3 meses, você precisou de atendimento de um Médico da unidade de saúde (posto de saúde) do SUS ou plano de saúde?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, e foi atendido',
      'Sim, mas não procurou atendimento',
      'Sim, mas não tinha vaga ou não conseguiu ser atendido'
    ]
  },
  {
    text: 'Nos últimos 3 meses, você precisou de atendimento de um Médico especialista do SUS ou plano de saúde?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, e foi atendido',
      'Sim, mas não procurou atendimento',
      'Sim, mas não tinha vaga ou não conseguiu ser atendido'
    ]
  },
  {
    text: 'Nos últimos 3 meses, você precisou de atendimento de um Outro profissional da saúde (dentista, fisioterapeuta, psicólogo, nutricionista, fonoaudiólogo, terapeuta ocupacional) do SUS ou plano de saúde?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, e foi atendido',
      'Sim, mas não procurou atendimento',
      'Sim, mas não tinha vaga ou não conseguiu ser atendido'
    ]
  },
  {
    text: 'Nos últimos 3 meses, você precisou de atendimento de um Outros atendimentos na unidade de saúde (medicações, curativos, vacinas que não são de COVID) do SUS ou plano de saúde?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, e foi atendido',
      'Sim, mas não procurou atendimento',
      'Sim, mas não tinha vaga ou não conseguiu ser atendido'
    ]
  },
  {
    text: 'Você parou de fazer alguma consulta de rotina que fazia antes da pandemia?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, mas já voltou a fazer',
      'Sim, mas ainda não voltou a fazer'
    ]
  },
  {
    text: 'Você parou de fazer algum exame de rotina que fazia antes da pandemia?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, mas já voltou a fazer',
      'Sim, mas ainda não voltou a fazer'
    ]
  },
  {
    text: 'Nos últimos 3 meses, você teve dificuldade para conseguir remédios no SUS que utiliza todos os dias?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, a receita venceu',
      'Sim, tinha receita, mas não conseguiu o remédio no SUS '
    ]
  },
  {
    text: 'Nos últimos 3 meses, precisou fazer alguma cirurgia?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, e foi realizada',
      'Sim, mas eu não quis realizar',
      'Sim, mas ainda não foi realizada porque não tinha vaga',
      'Sim, mas foi cancelada'
    ]
  },
  {
    text: 'Nos últimos 3 meses, você utilizou o Ligue-Saúde?',
    form_type: :radio,

    answers: [
      'Sim',
      'Não',
      'Não sei o que é o Ligue-Saúde'
    ]
  },
  {
    text: ' Está realizando exercícios físicos? ',
    form_type: :radio,

    answers: [
      'Não, e não fazia antes da pandemia',
      'Não, e fazia antes da pandemia ',
      'Sim, e não fazia antes da pandemia',
      'Sim, e já fazia antes da pandemia'
    ]
  },
  {
    text: 'Quantos dias por semana você faz exercícios físicos?',
    form_type: :radio,

    answers: [
      '0',
      '1-2',
      '3-4',
      '5 ou mais'
    ]
  },
  {
    text: 'Quanto tempo duram seus exercícios físicos?',
    form_type: :radio,

    answers: [
      'Não faço',
      '0 a 30 minutos',
      '30 a 40 minutos',
      '40 minutos ou mais'
    ]
  },
  {
    text: 'Com qual frequência você mede a pressão arterial?',
    form_type: :radio,

    answers: [
      'Todos os dias',
      'Uma ou mais vezes por semana',
      'Uma ou mais vezes por mês',
      'Uma ou mais vezes por ano',
      'Não meço há mais de um ano'
    ]
  },
  {
    text: 'Você perdeu ou ganhou peso durante a pandemia?',
    form_type: :radio,

    answers: [
      'Não mudou muito',
      'Ganhei mais de 5 kg',
      'Perdi mais de 5 kg'
    ]
  },
  {
    text: 'Você fuma (cigarro, cachimbo, charuto, cigarro de palha, mascar fumo, narguilé, entre outros)?',
    form_type: :radio,

    answers: [
      'Não, e nunca fumei',
      'Não, mas eu fumava',
      'Sim'
    ]
  },
  {
    text: 'Seu consumo de tabaco (cigarros e produtos) aumentou ou reduziu durante a pandemia?',
    form_type: :radio,

    answers: [
      'Não mudou ou nunca fumei',
      'Aumentou',
      'Diminuiu',
      'Comecei a fumar durante a pandemia',
      'Parei de fumar durante a pandemia'
    ]
  },
  {
    text: 'Com qual frequência você consome bebidas alcoólicas?',
    form_type: :radio,

    answers: [
      'Menos de uma vez por ano ou nunca bebi',
      'Menos de uma vez por mês',
      '1-3 vezes por mês',
      '1-4 vezes por semana',
      'Todos os dias ou quase todos'
    ]
  },
  {
    text: 'Quando você consome bebidas alcoólicas, quantas doses você costuma beber (uma dose corresponde a uma lata de cerveja, uma taça de vinho, ou uma dose de destilado)?',
    form_type: :radio,

    answers: [
      '0',
      '1-2',
      '3-4',
      '5-11',
      '12 ou mais'
    ]
  },
  {
    text: 'Seu consumo de bebida alcoólica mudou durante a pandemia?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, aumentou',
      'Sim, diminuiu'
    ]
  },
  {
    text: '(Para mulheres) Quando foi a última vez que você fez a mamografia?',
    form_type: :radio,

    answers: [
      'Nunca fez',
      'Menos de um ano',
      'Entre um e dois anos',
      'Entre dois e três anos',
      'Entre três e quatro anos',
      'Mais de quatro anos'
    ]
  },
  {
    text: '(Para mulheres) Quando foi a última vez que você fez o exame preventivo de colo de útero?',
    form_type: :radio,

    answers: [
      'Há menos de um ano',
      'Entre um e dois anos',
      'Entre dois e três anos',
      'Entre três e quatro anos',
      'Mais de quatro anos',
      'Nunca fez'
    ]
  },
  {
    text: 'Você foi prejudicado em sua saúde durante a pandemia?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, um pouco',
      'Sim, muito'
    ]
  },
  {
    text: 'Você se sentiu prejudicado no trabalho ou financeiramente durante a pandemia?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, um pouco',
      'Sim, muito'
    ]
  },
  {
    text: 'Você teve perda de alguma pessoa próxima por conta da COVID-19 ?',
    form_type: :radio,

    answers: %w[
      Não
      Sim
    ]
  },
  {
    text: 'Nos últimos 3 meses, você sentiu ansioso, deprimido, ou que precisava de ajuda psicológica?',
    form_type: :radio,

    answers: [
      'Não',
      'Sim, conversou com algum profissional da saúde sobre o problema',
      'Sim, mas não conseguiu ser atendido',
      'Sim, mas não procurou atendimento porque não quis (ou não quis falar sobre o assunto)'
    ]
  },
  {
    text: 'Se você precisou de atendimento no SUS, qual a nota você daria (0 para péssimo, 10 para excelente)?',
    form_type: :radio,

    answers: [
      'Não precisei',
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10'
    ]
  }
].each_with_index do |h, index|
  InquiryQuestion.find_or_initialize_by(text: h[:text]).tap do |question|
    position = index + 1
    answers = h.delete(:answers)

    question.attributes = h.merge(position: position, active: true)
    question.save!

    answers.each_with_index do |ah, a_index|
      a_position = a_index + 1

      question.inquiry_answers.find_or_initialize_by(text: ah).tap do |answer|
        answer.attributes = { position: a_position, active: true }
        answer.save!
      end
    end
  end
end
# rubocop:enable Layout/LineLength
