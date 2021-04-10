describe('patient appointment flow', () => {
  const cpf = '83274229792'

  beforeEach(() => {
    cy.appScenario('schedulling_is_enabled');
  })

  context('when schedulling is disabled', () => {
    beforeEach(() => {
      cy.appScenario('marvin_son_of_tristeza', { cpf: cpf });
      cy.appScenario('schedulling_is_disabled');
      cy.visit('/')
      cy.loginAsPatient(cpf)
    })
  
    context('when patient tries to create an appointment', () => {
      it('shows disabled schedulling message and does not creates an appointment', () => {
        cy.visit('/')
        cy.get('[data-cy=appointmentRescheduleButton]').click()
        cy.get('[data-cy=appointmentSchedullingIsDisabledText]').should('exist')
        cy.get('[data-cy=scheduledAppointmentText]').should('not.exist')
      })
    })

    context('when patient has appointment', () => {
      beforeEach(() => {
        cy.appScenario('appointment_today', { cpf: cpf });
      })

      it('shows disabled schedulling message', () => {
        cy.visit('/')
        cy.get('[data-cy=appointmentSchedullingIsDisabledText]').should('exist')
      })
    })
  })

  context('when patient cannot schedule', () => {
    beforeEach(() => {
      cy.appScenario('marvin_son_of_tristeza', { cpf: cpf, birth_date: '2000-06-08' });
      cy.visit('/')
      cy.loginAsPatient(cpf)
    })

    it('can see conditions unmet text and can not schedule appointment', () => {
      cy.visit('/')
      
      cy.get('[data-cy=conditionsUnmetText]').should('exist')
      cy.get('[data-cy=appointmentRescheduleButton]').should('not.exist')
    })

    context('when patient has previous scheduled appointment', () => {
      beforeEach(() => {
        cy.appScenario('appointment_today', { cpf: cpf });
        cy.visit('/')
      })

      it('can see and cancel own appointment, but can not re-schedule', () => {
        cy.get('[data-cy=scheduledAppointmentText]').should('exist')

        // Can not re-schedule
        cy.get('[data-cy=appointmentRescheduleButton]').click()
        cy.get('[data-cy=nextDayButton]').click()
        cy.get('[data-cy=ubs1Button]').click()
        cy.get('#ubs1 [data-cy=scheduleTimeButton]:first').click()
        cy.get('[data-cy=appointmentSchedulerConditionsUnmetAlertText]').should('exist')

        // Cancel
        cy.get('[data-cy=appointmentCancelButton]').click()
        cy.visit('/')
        cy.get('[data-cy=scheduledAppointmentText]').should('not.exist')
        cy.get('[data-cy=conditionsUnmetText]').should('exist')
        cy.get('[data-cy=appointmentRescheduleButton]').should('not.exist')
      })
    })
  })

  context('when patient can schedule', () => {
    beforeEach(() => {
      cy.appScenario('marvin_son_of_tristeza', { cpf: cpf });
      cy.visit('/')
      cy.loginAsPatient(cpf)
    })

    context('when there are doses', () => {
      it('can schedule, reschedule, and cancel', () => {
        cy.get('[data-cy=dosesAvailableText]').should('exist')

        cy.get('[data-cy=appointmentRescheduleButton]').click()
        cy.get('[data-cy=nextDayButton]').click()
        cy.get('[data-cy=ubs1Button]').click()
        cy.get('#ubs1 [data-cy=scheduleTimeButton]:first').click()
        cy.get('[data-cy=scheduledAppointmentText]').should('exist')

        cy.get('[data-cy=scheduledAppointmentText]').should('exist')

        cy.get('[data-cy=appointmentRescheduleButton]').click()
        cy.get('[data-cy=nextDayButton]').click()
        cy.get('[data-cy=ubs1Button]').click()
        cy.get('#ubs1 [data-cy=scheduleTimeButton]:first').click()
        cy.get('[data-cy=scheduledAppointmentText]').should('exist')

        cy.get('[data-cy=appointmentCancelButton]').click()
        cy.get('[data-cy=scheduledAppointmentText]').should('not.exist')
        cy.get('[data-cy=dosesAvailableText]').should('exist')
      })
    })

    context('when there are no doses available', () => {
      beforeEach(() => {
        cy.appScenario('no_appointments_available');
        cy.visit('/')
      })

      it('can see no appointments available text', () => {
        cy.get('[data-cy=noAppointmentsAvailableText]').should('exist')
      })
    })
  })

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
      cy.get('[data-cy=ubs1Button]').click()
      cy.get('#ubs1 [data-cy=scheduleTimeButton]:first').click()
      cy.get('[data-cy=appliedVaccineName]').should('contain', 'Coronavac')

      // Cancel and re-schedule
      cy.get('[data-cy=appointmentCancelButton]').click()
      cy.get('[data-cy=appointmentRescheduleButton]').click()
      cy.get('[data-cy=nextDayButton]').click()
      cy.get('[data-cy=ubs1Button]').click()
      cy.get('#ubs1 [data-cy=scheduleTimeButton]:first').click()
      cy.get('[data-cy=scheduledAppointmentText]').should('exist')

      cy.get('[data-cy=appliedVaccineName]').should('contain', 'Coronavac')
    })
  })

  context('when patient is already vaccinated', () => {
    beforeEach(()=>{
      cy.appScenario('vaccinated_patient', { cpf: cpf });

      cy.visit('/')
      cy.loginAsPatient(cpf)
    })

    it('render vaccinated patient page ', () => {
      cy.get('[data-cy=vaccinatedPatientText]').should('exist')
    })
  })
})
