// Run before each test (each 'it')
beforeEach(() => {
  cy.app('clean')
  cy.app('seed')
});
