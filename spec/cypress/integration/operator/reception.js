describe('reception flow', () => {
  let name, password, cpf

  before(() => {
    name = 'mlabs'
    password = 'dontpanic'
    cpf = '82920382640'
  })

  beforeEach(() => {
    cy.visit('/')
    cy.loginAsUbs(name, password)
  })

  context('patient has first dose appointment today', () => {
    beforeEach(() => {
      cy.get('[data-cy=searchInput]').type('Marvin10')
      cy.get('[data-cy=searchSubmit]').click()
    })

    it('finds and vaccinates the patient', () => {
      cy.get('[data-cy=patientCpf]').should('contain', '829.203.826-40')

      cy.get('[data-cy=checkInButton]').click()
      cy.get('[data-cy=checkInConfirmationButton]').click()

      cy.get('[data-cy=checked_inListTab]').click()
      cy.get('[data-cy=checkOutButton]').click()
      cy.get('[data-cy=vaccineRadioButton]').first().check()
      cy.get('[data-cy=checkOutConfirmationButton]').click()

      cy.get('[data-cy=backToCheckInListButton]').click()
      cy.get('[data-cy=operatorLogoutButton]').click()
      cy.loginAsPatient(cpf)
      cy.get('[data-cy=appliedVaccineName]').should('contain', 'AstraZeneca')
    })
  })

  context('patient has second dose appointment today', () => {
    const cpf = '71143168011'

    beforeEach(() => {
      cy.appScenario('second_dose_patient', { cpf: cpf, vaccine: 'CoronaVac', days_ago: 28 });
      cy.get('[data-cy=waitingListTab]').click()
      cy.get('[data-cy=searchInput]').type('second dose marvin')
      cy.get('[data-cy=searchSubmit]').click()
    })

    it('finds and vaccinates the patient', () => {
      cy.get('[data-cy=patientCpf]').should('contain', '711.431.680-11')

      cy.get('[data-cy=checkInButton]').click()
      cy.get('[data-cy=checkInConfirmationButton]').click()

      cy.get('[data-cy=checked_inListTab]').click()
      cy.get('[data-cy=checkOutButton]').click()
      cy.get('[data-cy=secondDoseVaccineText]').should('exist')
      cy.get('[data-cy=checkOutConfirmationButton]').click()

      cy.get('[data-cy=vaccineNameTag]').should('contain', 'CoronaVac') // same as first dose

      cy.get('[data-cy=backToCheckInListButton]').click()
      cy.get('[data-cy=operatorLogoutButton]').click()
      cy.loginAsPatient(cpf)
      cy.get('[data-cy=vaccinatedPatientText]').should('exist')
    })
  })

  context('patient has no appointment', () => {
    it('finds no patient', () => {
      cy.get('[data-cy=searchInput]').type('Deep Thought')
      cy.get('[data-cy=searchSubmit]').click()

      cy.get('[data-cy=noAppointmentsText]').should('exist')
    })
  })
})
