describe('patient appointment flow', () => {
  const cpf = '83274229792'

  beforeEach(() => {
    cy.visit('/')
  })

  // TODO:
  // context('when patient cannot schedule', () => {
  // })

  context('when patient can schedule', () => {
    beforeEach(() => {
      cy.appScenario('marvin_son_of_tristeza', { cpf: cpf });
      cy.visit('/')
      cy.loginAsPatient(cpf)
    })

    context('when there are doses', () => {
      it('can schedule, reschedule, and cancel', () => {
        cy.get('[data-cy=dosesAvailableText]').should('exist')

        // cy.get('[data-cy=scheduleAppointmentButton]').click()

        cy.get('[data-cy=appointmentRescheduleButton]').click()
        cy.get('[data-cy=nextDayButton]').click()
        cy.get('[data-cy=scheduleTimeButton]:last').click()
        cy.get('[data-cy=scheduledAppointmentText]').should('exist')

        cy.get('[data-cy=scheduledAppointmentText]').should('exist')

        cy.get('[data-cy=appointmentRescheduleButton]').click()
        cy.get('[data-cy=nextDayButton]').click()
        cy.get('[data-cy=scheduleTimeButton]:last').click()
        cy.get('[data-cy=scheduledAppointmentText]').should('exist')

        cy.get('[data-cy=appointmentCancelButton]').click()
        cy.get('[data-cy=scheduledAppointmentText]').should('not.exist')
        cy.get('[data-cy=dosesAvailableText]').should('exist')
      })
    })

    // TODO:
    // context('when there are no doses available', () => {
    // })
  })

  // TODO:
  // context('when appointment is in the past', () => {
  // })

  context('when patient is a second dose patient', () => {
    beforeEach(() => {
      cy.appScenario('second_dose_patient', {cpf: cpf});
      cy.visit('/')

      cy.loginAsPatient(cpf)
    })

    it('can replace same vaccine, and cancel and reschedule', () => {
      cy.get('[data-cy=appliedVaccineName]').should('contain', 'Coronavac')

      // Reschedule button
      cy.get('[data-cy=appointmentRescheduleButton]').click()
      cy.get('[data-cy=nextDayButton]').click()
      cy.get('[data-cy=scheduleTimeButton]:last').click()
      cy.get('[data-cy=appliedVaccineName]').should('contain', 'Coronavac')

      // Cancel and re-schedule
      cy.get('[data-cy=appointmentCancelButton]').click()

      // cy.get('[data-cy=scheduleAppointmentButton]').click()

      cy.get('[data-cy=appointmentRescheduleButton]').click()
      cy.get('[data-cy=nextDayButton]').click()
      cy.get('[data-cy=scheduleTimeButton]:last').click()
      cy.get('[data-cy=scheduledAppointmentText]').should('exist')

      cy.get('[data-cy=appliedVaccineName]').should('contain', 'Coronavac')
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
