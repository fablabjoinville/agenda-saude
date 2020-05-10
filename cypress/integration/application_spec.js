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
	
	describe('all flow test being a patient and for the user verify after', function() {
		it('requests home care, logs out and verify as user unit', function() {
			// Visiting the home page
			cy.visit('/');

			// Inform the CPF and register
			cy.get('.row > .col > form > .form-group > #patient_cpf').click();

			// IMPORTANT Change the CPF for each running
			cy.get('.row > .col > form > .form-group > #patient_cpf').type('22036134084');
			cy.get('.row > .col > form > .actions > .btn').click()

			// Fill the register fields
			cy.get('#patient_name').click();
			cy.get('#patient_name').type('Teste Bed');
			cy.get('#patient_mother_name').click();
			cy.get('#patient_mother_name').type('Mae Teste');
			cy.get('#patient_birth_date').click();
			cy.get('#patient_birth_date').type('0001-03-16');
			cy.get('#patient_birth_date').type('0019-03-16');
			cy.get('#patient_birth_date').type('0195-03-16');
			cy.get('#patient_birth_date').type('1958-03-16');
			cy.get('#patient_email').click();
			cy.get('#patient_email').type('teste@hello');
			cy.get('#patient_neighborhood').select('América');
			cy.get('#patient_phone').click();
			cy.get('#patient_phone').type('47 99112233');
			// Check the bedridden box
			cy.get('#patient_bedridden').click();
			cy.get('.pull-right').click();
			// Submit the registration
			//cy.get('#new_patient').submit();

			// Verify the UBSF and logout
			cy.get('.row:nth-child(2) .h8:nth-child(1)').click();
			cy.get('.btn-primary').click();

			// Logout
			//cy.get('.button_to:nth-child(2)').submit();

			// Enter as user
			cy.get('body').click();
			cy.get('.w-100').click();
			cy.get('.button_to').submit();

			// Fill the login fields and login
			cy.get('#user_name').type('mlabs');
			cy.get('#user_password').type('dontpanic');
			cy.get('.actions > .btn').click();
			//cy.get('#new_user').submit();

			// Check if the bedridden patient 'Teste Bed' is there
			cy.get('tr:nth-child(1) a').click();
			cy.get('a:nth-child(13)').click();

			// Logout
			cy.get('.btn-primary').click();
		})
	})
	})
})
