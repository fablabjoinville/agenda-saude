describe('ubs appointments list', () => {
  const [name, password] = ['mlabs', 'dontpanic']

  beforeEach(() => {
    cy.visit('/')

    cy.loginAsUbs(name, password)

    cy.visit('/ubs')
  })

  context('when has patients scheduled to today', () => {
    it('show appointments list', () => {
      cy.get('[data-cy=appointment1800]').should('exist')
    })

      context('navigating the pages', () => {
        it('shows the last patient for the day', () => {
          cy.get('[data-cy=nextPageLink]').click()
	  cy.get('[data-cy=appointment2130]').should('exist')
	})
      })
  })

  context('when has no patients scheduled to today', () => {
    beforeEach(() => {
      cy.appScenario('no_patients_scheduled')

      cy.visit('/ubs')
    })

    it('show no appointments text', () => {
      cy.get('[data-cy=noAppointmentsYetText]').should('exist')
    })
  })
})
