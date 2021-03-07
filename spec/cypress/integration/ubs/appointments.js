describe('appointments list', () => {
  let name, password

  before(() => {
    name = 'mlabs'
    password = 'dontpanic'
  })

  beforeEach(() => {
    cy.visit('/')
  })

  context('when has patients scheduled to today', () => {
    it('show appointments list', () => {
      cy.loginAsUbs(name, password)

      cy.get('[data-cy=appointment]').should('exist')
    })
  })

  context('when has no patients scheduled to today', () => {
    beforeEach(() => {
      cy.appScenario('no_patients_scheduled')
    })

    it('show no appointments text', () => {
      cy.loginAsUbs(name, password)

      cy.get('[data-cy=noAppointmentsYetText]').should('exist')
    })
  })
})
