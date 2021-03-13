patient = Patient.find_by(cpf: command_options['cpf'])
patient.update!(birth_date: '2000-01-31')
