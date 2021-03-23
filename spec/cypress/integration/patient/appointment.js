describe('patient appointment flow', () => {
  const cpf = '83274229792'

  beforeEach(() => {
    cy.visit('/')
  })

  context('when patient is a second dose patient', () => {
    beforeEach(() => {
      cy.appScenario('second_dose_patient', { cpf: cpf });
      
      cy.visit('/')
      
      cy.loginAsPatient(cpf)
    })
    
    it('can cancel and reeschedule same vaccine', () => {
      cy.get('[data-cy=appliedVaccineName]').should('contain', 'Coronavac')

      cy.get('[data-cy=cancelAppointmentButton]').click()
      cy.createOrReplaceAppointment()

      cy.get('[data-cy=appliedVaccineName]').should('contain', 'Coronavac')
    })
  })

  context('when patient is not already vaccinated', () => {
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
    })

    context('when has no future appointment scheduled', () => {
      context('when patient is allowed', () => {
        it('create appointment', () => {
          cy.createOrReplaceAppointment()

          cy.get('[data-cy=currentAppointmentText]').should('exist')
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
    })
  })

  context('when patient is already vaccinated', () => {
    beforeEach(()=>{
      cy.appScenario('vaccinated_patient', { cpf: cpf });

      cy.loginAsPatient(cpf)
    })

    it('render vaccinated patient page ', () => {
      cy.get('[data-cy=vaccinatedPatientText]').should('exist')
    })
  })
})
