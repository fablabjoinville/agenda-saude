Cypress.Commands.add('signupPatient', (cpf) => {
  cy.get('#patient_cpf').type(cpf)
  cy.get('[data-cy=signUpButton]').click()

  cy.get('#patient_name').type('Marvin')
  cy.get('#patient_birthday_3i').select('1')
  cy.get('#patient_birthday_2i').select('janeiro')
  cy.get('#patient_birthday_1i').select('1950')
  cy.get('#patient_mother_name').type('Tristeza')
  cy.get('#patient_email').type('marvin@mlabs.com')
  cy.get('#patient_sus').type('957774523900005')
  cy.get('#patient_public_place').type('Galáxia')
  cy.get('#patient_place_number').type('X9')
  cy.get('#patient_neighborhood').select('Glória')
  cy.get('#patient_phone').type('4899999999')
  cy.get('#patient_other_phone').type('47988888888')
  cy.get('#patient_groups_1').check()
  cy.get('#patient_groups_29').check()
  cy.get('[data-cy=patientSubmitButton]').click()
})

Cypress.Commands.add('loginAsPatient', (cpf) => {
  cy.get('[data-cy=cpfInputField]').type(cpf)
  cy.get('[data-cy=signUpButton]').click()
  cy.get('[data-cy=TristezaMotherButton]').click()
})

Cypress.Commands.add('loginAsUbs', (name, password) => {
  cy.get('[data-cy=userLoginButton]').click()
  cy.get('[data-cy=nameInputField]').type(name)
  cy.get('[data-cy=passwordInputField]').type(password)
  cy.get('[data-cy=loginButton]').click()
})
