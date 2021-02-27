describe('patient appointment flow', () => {
  let cpf

  before(() => {
    cpf = '83274229792'
  })

  beforeEach(() => {
    cy.visit('/')

    cy.appScenario('marvin_son_of_tristeza', { cpf: cpf })

    cy.loginAsPatient(cpf)
  })

  context('when has future appointment scheduled', () => {
    beforeEach(() => {
      cy.appScenario('appointment_today', { cpf: cpf });

      cy.visit('/')
    })

    it('replace appointment', () => {
      cy.createOrReplaceAppointment()

      cy.get('[data-cy=currentAppointmentText]').should('exist')
    })

    it('cancel appointment', () => {
      cy.get('[data-cy=cancelAppointmentButton]').click()
      cy.get('[data-cy=noAppointmentYetText]').should('exist')
    })

    context('when patient became not allowed', () => {
      beforeEach(() => {
        cy.get('[data-cy=editPatientButton]').click()
        cy.get('#patient_birth_date_1i').select('2000')
        cy.get('[data-cy=updatePatientButton]').click()
      })

      it('replace appointment', () => {
        cy.createOrReplaceAppointment()

        cy.get('[data-cy=currentAppointmentText]').should('exist')
      })

      it('cancel appointment and renders not allowed', () => {
        cy.get('[data-cy=cancelAppointmentButton]').click()
        cy.get('[data-cy=patientNotAllowedText]').should('exist')
      })
    })
  })

  context('when has no future appointment scheduled', () => {
    context('when patient is allowed', () => {
      it('create appointment', () => {
        cy.createOrReplaceAppointment()

        cy.get('[data-cy=currentAppointmentText]').should('exist')
      })
    })

    context('when patient is not allowed', () => {
      beforeEach(() => {
        cy.get('[data-cy=editPatientButton]').click()
        cy.get('#patient_birth_date_1i').select('2000')
        cy.get('[data-cy=updatePatientButton]').click()
      })

      it('renders not allowed', () => {
        cy.get('[data-cy=patientNotAllowedText]').should('exist')
      })
    })
  })

  context('when has no future appointment scheduled', () => {
    it('create appointment', () => {
      cy.createOrReplaceAppointment()

      cy.get('[data-cy=currentAppointmentText]').should('exist')
    })
  })

  context('when patient not attended yesterday', () => {
    beforeEach(() => {
      cy.appScenario('appointment_no_attended_yesterday', { cpf: cpf });
    })

    it('has no appointment scheduled', () => {
      cy.get('[data-cy=noAppointmentYetText]').should('exist')
    })

    it('create appointment', () => {
      cy.createOrReplaceAppointment()

      cy.get('[data-cy=currentAppointmentText]').should('exist')
    })

    context('when patient became not allowed', () => {
      beforeEach(() => {
        cy.get('[data-cy=editPatientButton]').click()
        cy.get('#patient_birth_date_1i').select('2000')
        cy.get('[data-cy=updatePatientButton]').click()
      })

      it('renders not allowed', () => {
        cy.get('[data-cy=patientNotAllowedText]').should('exist')
      })
    })
  })
})
