describe('patient appointment flow', () => {
  const cpf = '83274229792'

  beforeEach(() => {
    cy.visit('/')

    cy.appScenario('marvin_son_of_tristeza', { cpf: cpf })

    cy.loginAsPatient(cpf)
  })

  context('when has future appointment scheduled', () => {
    beforeEach(() => {
      cy.appScenario('appointment_today', { cpf: cpf });

      cy.visit('/')
    })

    it('replace appointment', () => {
      cy.createOrReplaceAppointment()

      cy.get('[data-cy=currentAppointmentText]').should('exist')
    })

    it('cancel appointment', () => {
      cy.get('[data-cy=cancelAppointmentButton]').click()
      cy.get('[data-cy=noAppointmentYetText]').should('exist')
    })
  })

  context('when has no future appointment scheduled', () => {
    it('create appointment', () => {
      cy.createOrReplaceAppointment()

      cy.get('[data-cy=currentAppointmentText]').should('exist')
    })
  })

  context('when patient not attended yesterday', () => {
    beforeEach(() => {
      cy.appScenario('appointment_no_attended_yesterday', { cpf: cpf });
    })

    it('has no appointment scheduled', () => {
      cy.get('[data-cy=noAppointmentYetText]').should('exist')
    })
  })
})
