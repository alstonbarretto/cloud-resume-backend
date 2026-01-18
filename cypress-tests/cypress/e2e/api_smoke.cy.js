describe('Backend API Smoke Test', () => {
  it('returns a valid counter response', () => {
    const apiUrl = Cypress.config('baseUrl');
    
    cy.request({
      method: 'GET',
      url: apiUrl,  // Use base URL directly
      failOnStatusCode: false
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body).to.have.property('count');
    });
  });
});