Cypress.Commands.add('signupPatient', (cpf) => {
  cy.get('[data-cy=cpfInputField]').type(cpf)
  cy.get('[data-cy=signUpButton]').click()

  cy.get('[data-cy=newPatientNameInputField]').type('Marvin')
  cy.get('[data-cy=newPatientEmailInputField]').type('marvin@mlabs.com')
  cy.get('#patient_birth_date_3i').select('1')
  cy.get('#patient_birth_date_2i').select('janeiro')
  cy.get('#patient_birth_date_1i').select('1900')
  cy.get('[data-cy=newPatientMotherNameInputField]').type('Tristeza')
  cy.get('[data-cy=patientGroups]').get('[type="checkbox"]').first().check()
  cy.get('[data-cy=newPatientSusNumberInputField]').type('957774523900005')
  cy.get('[data-cy=newPatientStreetNameInputField]').type('Galáxia')
  cy.get('[data-cy=newPatientStreetNumberInputField]').type('X9')
  cy.get('[data-cy=newPatientNeighborhoodNameInputField]').select('Glória')
  cy.get('[data-cy=newPatientPhoneNumberInputField]').type('4899999999')
  cy.get('[data-cy=newPatientOtherPhoneNumberInputField]').type('47988888888')
  cy.get('#patient_groups_1')
  cy.get('#patient_groups_26').click()
  cy.get('[data-cy=newPatientSubmitButton]').click()
})

Cypress.Commands.add('createOrReplaceAppointment', () => {
  cy.get('[data-cy=ubsTimeSlots]').click({ multiple: true })
  cy.get('.btn-success').first().click()
  cy.get('[data-cy=backButton]').click()
})

Cypress.Commands.add('loginAsPatient', (cpf) => {
  cy.get('[data-cy=cpfInputField]').type(cpf)
  cy.get('[data-cy=signUpButton]').click()
  cy.get('[data-cy=TristezaButtom]').click()
  cy.get('[data-cy=loginButtom]').click()
})

Cypress.Commands.add('loginAsUbs', (name, password) => {
  cy.get('[data-cy=userLoginButton]').click()
  cy.get('[data-cy=nameInputField]').type(name)
  cy.get('[data-cy=passwordInputField]').type(password)
  cy.get('[data-cy=loginButton]').click()
})
