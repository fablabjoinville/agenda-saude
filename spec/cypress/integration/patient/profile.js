describe('patient profile', () => {
  const cpf = '83274229792'

  beforeEach(() => {
    cy.visit('/')
  })

  context('when patient is not registered', () => {
    it('signup', () => {
      cy.signupPatient(cpf)

      cy.get('[data-cy=editPatientButton]').should('exist')
    })
  })

  context('when patient is already registered', () => {
    beforeEach(() => {
      cy.appScenario('marvin_son_of_tristeza', { cpf: cpf });
    })

    context('when patient is not logged', () => {
      it('login', () => {
        cy.loginAsPatient(cpf)

        cy.get('[data-cy=editPatientButton]').should('exist')
      })
    })

    context('when patient is already logged', () => {
      beforeEach(() => {
        cy.loginAsPatient(cpf)
      })

      it('logout', () => {
        cy.get('[data-cy=logoutButton]').click()

        cy.get('[data-cy=cpfInputField]').should('exist')
      })

      it('edit profile', () => {
        cy.get('[data-cy=editPatientButton]').click()
        cy.get('[data-cy=editPatientNeighborhoodNameInputField]').select('América')
        cy.get('[data-cy=updatePatientButton]').click()

        cy.get('[data-cy=alertMessage]').should('exist')
      })
    })
  })
})
