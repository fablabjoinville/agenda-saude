describe('operator appointments list', () => {
  const [name, password] = ['mlabs', 'dontpanic']

  beforeEach(() => {
    cy.visit('/')

    cy.loginAsUbs(name, password)

    cy.visit('/operator')
  })

  context('when has patients scheduled to today', () => {
    it('show appointments list', () => {
      cy.get('[data-cy=appointment1900]').should('exist')
    })

      context('navigating the pages', () => {
        it('shows the last patient for the day', () => {
          cy.get('[data-cy=nextPageLink]').click()
	  cy.get('[data-cy=appointment2140]').should('exist')
	})
      })
  })

  context('when has no patients scheduled to today', () => {
    beforeEach(() => {
      cy.appScenario('no_patients_scheduled')

      cy.visit('/operator')
    })

    it('show no appointments text', () => {
      cy.get('[data-cy=noAppointmentsYetText]').should('exist')
    })
  })
})
