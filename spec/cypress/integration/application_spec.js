describe('happy patient flow', () => {
  it('visits the home page and creates appointments', () => {
    cy.visit('/')

    cy.get('[data-cy=cpfInputField]').type('83274229792')
    cy.get('[data-cy=signUpButton]').click()
    cy.get('[data-cy=signUpText]').should('exist')

    cy.get('[data-cy=newPatientNameInputField]').type('Marvin')
    cy.get('[data-cy=newPatientEmailInputField]').type('marvin@mlabs.com')
    cy.get('#patient_birth_date_3i').select('1')
    cy.get('#patient_birth_date_2i').select('Janeiro')
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
    cy.get('#patient_groups_23').click()
    cy.get('#patient_groups_57').click()
    cy.get('[data-cy=newPatientSubmitButton]').click()
    cy.get('[data-cy=noAppointmentYetText]').should('exist')

    // create appointment for the first time
    cy.get('[data-cy=ubsTimeSlots]').click()
    cy.get('.btn-success').last().click()
    cy.get('[data-cy=successfullAppointmentCreatedText]').should('exist')
    cy.get('[data-cy=backButton]').click()
    cy.get('[data-cy=currentAppointmentText]').should('exist')

    // substitute appointment
    cy.get('[data-cy=ubsTimeSlots]').click()
    cy.get('.btn-success').last().click()
    cy.get('[data-cy=successfullAppointmentCreatedText]').should('exist')
    cy.get('[data-cy=backButton]').click()
    cy.get('[data-cy=currentAppointmentText]').should('exist')

    // cancel appointment
    cy.get('[data-cy=cancelAppointmentButton]').click()
    cy.get('[data-cy=noAppointmentYetText]').should('exist')

    // create appointment for the second time
    cy.get('[data-cy=ubsTimeSlots]').click()
    cy.get('.btn-success').last().click()
    cy.get('[data-cy=successfullAppointmentCreatedText]').should('exist')
    cy.get('[data-cy=backButton]').click()
    cy.get('[data-cy=currentAppointmentText]').should('exist')

    // edit patient
    cy.get('[data-cy=editPatientButton]').click()
    cy.get('[data-cy=editPatientNeighborhoodNameInputField]').select('América')
    cy.get('[data-cy=updatePatientButton]').click()
    cy.get('[data-cy=alertMessage]').should('exist')

    // logout and login
    cy.get('[data-cy=logoutButton]').click()
    cy.get('[data-cy=cpfInputField]').type('83274229792')
    cy.get('[data-cy=signUpButton]').click()
    cy.get('[data-cy=TristezaButtom]').click()
    cy.get('[data-cy=loginButtom]').click()
    cy.get('[data-cy=currentAppointmentText]').should('exist')
  })
})
