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
      cy.get('[data-cy=checkInSearchTab]').click()
      cy.get('[data-cy=searchPatientByNameInputField]').type('Marvin10')
      cy.get('[data-cy=submitSearchButton]').click()
    })

    it('finds and vaccinates the patient', () => {
      cy.get('[data-cy=checkInPatientCpf]').should('contain', '829.203.826-40')

      cy.get('[data-cy=patientCheckIn]').click()
      cy.get('[data-cy=executePatientCheckIn]').click()

      cy.get('[data-cy=checkInOkTag]').should('exist')
      cy.get('[data-cy=goBackToCheckInSearchButton]').click()

      cy.get('[data-cy=checkOutListTab]').click()
      cy.get('[data-cy=patientCheckOut]').click()
      cy.get('[data-cy=vaccineSelect]').select('Coronavac')
      cy.get('[data-cy=executePatientCheckOut]').click()

      cy.get('[data-cy=secondDoseScheduledText]').should('exist')
      cy.get('[data-cy=secondDoseScheduledTag]').should('exist')
      cy.get('[data-cy=vaccineNameTag]').should('contain', 'Coronavac')

      cy.get('[data-cy=goBackToCheckOutListButton]').click()
      cy.get('[data-cy=checkOutPatientNotFoundText]').should('exist')

      cy.get('[data-cy=ubsLogoutButton]').click()
      cy.loginAsPatient(cpf)
      cy.get('[data-cy=appliedVaccineName]').should('contain', 'Coronavac')
    })
  })

  context('patient has second dose appointment today', () => {
    const cpf = '71143168011'

    beforeEach(() => {
      cy.appScenario('second_dose_patient', { cpf: cpf });
      cy.get('[data-cy=checkInSearchTab]').click()
      cy.get('[data-cy=searchPatientByNameInputField]').type('second dose marvin')
      cy.get('[data-cy=submitSearchButton]').click()
    })

    it('finds and vaccinates the patient', () => {
      cy.get('[data-cy=checkInPatientCpf]').should('contain', '711.431.680-11')

      cy.get('[data-cy=patientCheckIn]').click()
      cy.get('[data-cy=executePatientCheckIn]').click()

      cy.get('[data-cy=checkInOkTag]').should('exist')
      cy.get('[data-cy=goBackToCheckInSearchButton]').click()

      cy.get('[data-cy=checkOutListTab]').click()
      cy.get('[data-cy=patientCheckOut]').click()

      cy.get('[data-cy=secondDoseTag]').should('exist')
      cy.get('[data-cy=vaccineNameTag]').should('contain', 'Coronavac')
      
      cy.get('[data-cy=executePatientCheckOut]').click()

      cy.get('[data-cy=secondDoseDone]').should('exist')
      cy.get('[data-cy=checkoutTag]').should('exist')
      cy.get('[data-cy=secondDoseTag]').should('exist') 
      cy.get('[data-cy=vaccineNameTag]').should('contain', 'Coronavac')

      cy.get('[data-cy=goBackToCheckOutListButton]').click()
      cy.get('[data-cy=checkOutPatientNotFoundText]').should('exist')

      cy.get('[data-cy=ubsLogoutButton]').click()
      cy.loginAsPatient(cpf)
      cy.get('[data-cy=vaccinatedPatientText]').should('exist')
    })
  })

  context('patient has no appointment', () => {
    it('finds no patient', () => {
      cy.get('[data-cy=checkInSearchTab]').click()
      cy.get('[data-cy=searchPatientByNameInputField]').type('Deep Thought')
      cy.get('[data-cy=submitSearchButton]').click()

      cy.get('[data-cy=patientNotFoundText]').should('exist')
    })
  })
})
