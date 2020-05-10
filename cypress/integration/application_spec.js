describe('Bedridden flow', () => {
  it('visits home page', () => {
    cy.visit('/')

    cy.get('.row > .col > form > .form-group > #patient_cpf').type('83274229792')
    cy.get('.row > .col > form > .actions > .btn').click()

    expect(true).to.equal(true)
  })

	describe('user already exists and has appointment', function() {
		it('requests home care, logs out and logs in again', function() {
		//Login
		cy.visit('/')

		// Inform CPF and enter
		cy.get('.row > .col > form > .form-group > #patient_cpf').click()
		cy.get('.row > .col > form > .form-group > #patient_cpf').type('82920382640')
		cy.get('.row > .col > form > .actions > .btn').click()

		// Select correct mother name and enter
		cy.get('.row > .col > #new_patient > .form-group > #patient_password').select('Num')
		cy.get('.row > .col > #new_patient > .actions > .btn').click()

		// Click on request home care
		cy.get('.container > .alert > .col > .button_to > .btn').click()

		// Logout
		cy.get('body > .navbar > .button_to > .btn').click()

		// Login again
		cy.get('.row > .col > form > .form-group > #patient_cpf').click()
		cy.get('.row > .col > form > .form-group > #patient_cpf').type('82920382640')
		cy.get('.row > .col > form > .actions > .btn').click()

		cy.get('.row > .col > #new_patient > .form-group > #patient_password').select('Num')
		cy.get('.row > .col > #new_patient > .actions > .btn').click()

		// Assert home care message
		cy.get('body > .container > .row > .col > .h3').contains('Pronto! Atendimento em domicílio solicitado')
		})
	})
})
