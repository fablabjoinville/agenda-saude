describe('patient appointment flow', () => {
  let cpf

  before(() => {
    cpf = '83274229792'
  })

  beforeEach(() => {
    cy.visit('/')
  })

  context('when patient not attended yesterday', () => {
    beforeEach(() => {
      cy.appScenario('marvin_son_of_tristeza', { cpf: cpf })

      cy.loginAsPatient(cpf)
    })

    it('create appointment', () => {
      cy.createOrReplaceAppointment()

      cy.get('[data-cy=currentAppointmentText]').should('exist')
    })

    it('replace appointment', () => {
      cy.createOrReplaceAppointment()
      cy.createOrReplaceAppointment()

      cy.get('[data-cy=currentAppointmentText]').should('exist')
    })

    it('cancel appointment', () => {
      cy.createOrReplaceAppointment()

      cy.get('[data-cy=cancelAppointmentButton]').click()
      cy.get('[data-cy=noAppointmentYetText]').should('exist')
    })
  })

  context('when patient not attended yesterday', () => {
    beforeEach(() => {
      cy.appScenario('marvin_son_of_tristeza', { cpf: cpf });
      cy.appScenario('appointment_no_attended_yesterday', { cpf: cpf });
    })

    it('has no appointment scheduled', () => {
      cy.loginAsPatient(cpf)

      cy.get('[data-cy=noAppointmentYetText]').should('exist')
    })
  })
})
