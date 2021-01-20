describe('new patient flow', () => {
  it('visits home page', () => {
    cy.visit('/')

    cy.get('[data-cy=cpfInputField]').type('83274229792')
    cy.get('[data-cy=signUpButton]').click()

    cy.get('[data-cy=signUpText]').should('exist')
  })
})
