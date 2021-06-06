# Estrutura de dados

## appointments

Agendamentos, funciona como uma agenda onde vagas podem ser abertas. Agendamentos podem estar tanto vagos (sem um `patient_id`) quanto preenchidos.

  * `start`: data e horário de início da vaga.
  * `end`: data e horário de fim da vaga.
  * `active`: se agendamento está ativo ou suspenso. Pode estar suspenso por problemas com o paciente (por exemplo a idade não condiz com seu documento de identidade), ou pode ser usado para suspender vagas futuras afim de criar uma reserva de vagas para imprevistos.
  * `ubs_id`: unidade onde este agendamento será feito.
  * `patient_id`: paciente. Se estiver em branco, é uma vaga disponível para agendamento.
  * `check_in`: data e horário do check in na unidade. É realizado quando o paciente chega, se apresenta e todos os documentos estão em ordem.
  * `check_out`: data e horeario de check out na unidade. É realizado quando o paciente recebeu a dose e saiu.
  * `suspend_reason`: motivo pelo qual esta dose foi suspença (pode não ter motivo).
  * `vaccine_name`: nome da vacina administrada ou agendada para o futuro, caso seja segunda dose. **A ser removido no futuro, mas por hora ainda usado.**

## conditions

Condições de agendamento, que possibilitam que vagas sejam agendadas.

  * `name`: nome (título) da condição, a ser mostrado na página inicial.
  * `start_at`: a partir de quando é válida.
  * `end_at`: até quando é válida.
  * `min_age`: idade mínima (opcional).
  * `max_age`: idade máxima (opcional)
  * `can_register`: mostra na lista de "grupos que podem cadastrar"
  * `can_schedule`: mostra na lista de "grupos que podem agendar"
  * `created_at`: data que condição foi criada.
  * `updated_at`: data que condição foi atualizada.

## conditions_groups

Associativa entre condições e grupos.

## conditions_ubs

Associativa entre condições e unidades.

## doses

Doses administradas da vacina em pacientes.

  * `patient_id`: Paciente do qual esta dose foi administrada.
  * `appointment_id`: Agendamento no qual esta dose foi administrada. Útil para inferir em qual unidade (`ubs`) a dose foi realizada.
  * `vaccine_id`: Vacina que foi administrada.
  * `sequence_number`: Número da dose (1 para primeira dose, 2 para segunda dose, ...)
  * `created_at`: Data que a dose foi administrada.
  * `follow_up_appointment_id`: Agendamento do reforço desta dose.

## groups

Grupos do qual o paciente participa.

  * `name`: Nome do grupo. Exemplo: "Trabalhadores de Saúde".
  * `parent_group_id`: Se este elemento é "filho" de algum outro grupo. Por exemplo, "Enfermeiros" ser um filho de "Trabalhadores de Saúde".
  * `position`: Posição na lista.
  * `context`: Contexto, sendo 0 para grupos Prioritarios e 1 para Comorbidades.
  * `active`: Se grupo está ativo ou não (neste caso não aparece mais).

## groups_patients

Tabela associativa entre `groups` e `patients`. É como sabemos quantos pacientes estão em quantos grupos.

## inquiry_answers

Respostas (alternativas) das perguntas do inquérito.

  * `text`: texto da resposta.
  * `inquiry_question_id`: de qual pergunta esta resposta faz parte.
  * `position`: posição.
  * `active`: se está ativa.

## inquiry_questions

Perguntas do inquérito.

  * `text`: texto da pergunta.
  * `form_type`: tipo de pergunta.
  * `position`: posição.
  * `active`: se está ativa.

## neighborhoods

Bairros da cidade.

  * `name`: nome do bairro.

## neighborhoods_ubs

Tabela associativa entre `ubs` e `neighborhood`, já que unidades de atendimento podem atender múltiplos bairros da cidade.

pages", force: :cascade do |t|
t.string "path", null: false
t.string "title", null: false
t.text "body", null: false
t.integer "context", null: false
t.datetime "created_at", precision: 6, null: false
t.datetime "updated_at

## patients

Pacientes.

  * `email`: email do paciente.
  * `created_at`:
  * `updated_at`:
  * `name`: nome do paciente.
  * `cpf`: número de CPF, usado para login.
  * `mother_name`: nome da mãe.
  * `birth_date`: data de nascimento.
  * `phone`: número telefônico primário.
  * `other_phone`: número telefônico secundário.
  * `sus`: número do cartão do SUS.
  * `fake_mothers`: nomes falsos de mães. Usado para desafiar o usuário no login.
  * `login_attempts`: tentativas falhas de login. Usado para bloquear acesso após um número de tentativas falhas.
  * `public_place`: endereço residencial.
  * `place_number`: número residencial.
  * `neighborhood_id`:  bairro.
  * `street_2`: complemento residencial
  * `internal_note`: observação interna sobre o usuário, **ainda não em uso**.
  * `user_updated_at`: quando o paciente atualizou seu cadastro. Só registrado se foi o paciente (não registra se foi atualizado por operador).

## patients_inquiry_answers

Associativa entre pacientes e as respostas dos inquéritos.

## ubs

Unidades de saúde.

  * `name`: nome da unidade de saúde.
  * `shift_start`:
  * `shift_end`:
  * `break_start`:
  * `break_end`:
  * `slot_interval_minutes`:
  * `created_at`:
  * `updated_at`:
  * `phone`:
  * `address`:
  * `cnes`:
  * `active`:
  * `open_saturday`:
  * `saturday_shift_start`:
  * `saturday_break_start`:
  * `saturday_break_end`:
  * `saturday_shift_end`:
  * `appointments_per_time_slot`:
  * `sunday_shift_start`:
  * `sunday_break_start`:
  * `sunday_break_end`:
  * `sunday_shift_end`:
  * `neighborhood_id`:

## ubs_users

Tabela associativa entre `ubs` e `patients`.

## users

  * `email`: email do usuário, **não é usado**.
  * `encrypted_password`:
  * `reset_password_token`:
  * `reset_password_sent_at`:
  * `remember_created_at`:
  * `name`: Nome do administrador, também usado como login.
  * `administrator`: Se usuário é administrador ou não.

## vaccines

Tipos de vacinas disponíveis no sistema.

  * `name`: Nome informal da vacina.
  * `formal_name`: Nome formal da vacina, a título informativo.
  * `second_dose_after_in_days`: Após quantos dias a segunda dose deve ser administrada. Pode ser `NULL~ se não houver segunda dose.
  * `third_dose_after_in_days`: Após quantos dias a terceira dose deve ser administrada. Pode ser `NULL` se não houver terceira dose.
  * `legacy_name`: Nome de legado, para migração de dados. A ser removida em breve.
