describe('patient appointment flow', () => {
  const cpf = '83274229792'

  beforeEach(() => {
    cy.visit('/')
  })

  context('when patient is not already vaccineted', () => {
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
          cy.appScenario('young_marvin_son_of_tristeza', { cpf: cpf });

          cy.visit('/')
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
          cy.appScenario('young_marvin_son_of_tristeza', { cpf: cpf });

          cy.visit('/')
        })

        it('renders not allowed', () => {
          cy.get('[data-cy=patientNotAllowedText]').should('exist')
        })
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
          cy.appScenario('young_marvin_son_of_tristeza', { cpf: cpf });

          cy.visit('/')
        })

        it('renders not allowed', () => {
          cy.get('[data-cy=patientNotAllowedText]').should('exist')
        })
      })
    })
  })

  context('when patient is already vaccineted', () => {
    beforeEach(()=>{
      cy.appScenario('vaccinated_patient', { cpf: cpf });

      cy.loginAsPatient(cpf)
    })

    it('render vaccinated patient page ', () => {
      cy.get('[data-cy=vaccinetedPatientText]').should('exist')
    })
  })
})