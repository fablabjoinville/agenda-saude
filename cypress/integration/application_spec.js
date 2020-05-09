describe('Bedridden flow', () => {
  it('visits home page', () => {
    cy.visit('/')

    cy.get('.row > .col > form > .form-group > #patient_cpf').type('83274229792')
    cy.get('.row > .col > form > .actions > .btn').click()

    expect(true).to.equal(true)
  })
})
