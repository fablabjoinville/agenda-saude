describe('patient profile', () => {
  const cpf = '83274229792'

  beforeEach(() => {
    cy.visit('/')
  })

  context('when patient is not registered', () => {
    it('signup', () => {
      cy.signupPatient(cpf)

      cy.get('[data-cy=patientEditButton]').should('exist')
    })
  })

  context('when patient is already registered', () => {
    beforeEach(() => {
      cy.appScenario('marvin_son_of_tristeza', { cpf: cpf });
    })

    context('when patient is not logged', () => {
      it('login', () => {
        cy.loginAsPatient(cpf)

        cy.get('[data-cy=patientEditButton]').should('exist')
      })
    })

    context('when patient is already logged', () => {
      beforeEach(() => {
        cy.loginAsPatient(cpf)
      })

      it('logout', () => {
        cy.get('[data-cy=patientLogoutButton]').click()

        cy.get('[data-cy=cpfInputField]').should('exist')
      })

      it('edit profile', () => {
        cy.get('[data-cy=patientEditButton]').click()
        cy.get('#patient_neighborhood').select('América')
        cy.get('[data-cy=patientSubmitButton]').click()
        cy.get('[data-cy=noticeMessage]').should('exist')
      })
    })
  })
})
