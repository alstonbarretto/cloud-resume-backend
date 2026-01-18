describe('Resume Visitor Counter API', () => {
  const apiUrl = Cypress.config('baseUrl');
  const expectedOrigin = Cypress.env('expectedOrigin');

  beforeEach(() => {
    cy.log(`Testing API at: ${apiUrl}`);
  });

  it('should return 200 status code', () => {
    cy.request({
      method: 'GET',
      url: apiUrl,
      failOnStatusCode: false
    }).then((response) => {
      expect(response.status).to.eq(200);
    });
  });

  it('should return valid JSON response', () => {
    cy.request('GET', apiUrl)
      .its('headers')
      .its('content-type')
      .should('include', 'application/json');
  });

  it('should include CORS headers with correct origin', () => {
    cy.request('GET', apiUrl)
      .its('headers')
      .should((headers) => {
        expect(headers).to.have.property('access-control-allow-origin');
        expect(headers['access-control-allow-origin']).to.eq(expectedOrigin);
      });
  });

  it('should return a count property in response body', () => {
    cy.request('GET', apiUrl)
      .its('body')
      .should('have.property', 'count')
      .and('be.a', 'number')
      .and('be.greaterThan', 0);
  });

  it('should increment visitor count on multiple requests', () => {
    let firstCount;

    // First request
    cy.request('GET', apiUrl)
      .its('body.count')
      .then((count) => {
        firstCount = count;
        expect(firstCount).to.be.a('number');
      });

    // Second request
    cy.request('GET', apiUrl)
      .its('body.count')
      .then((secondCount) => {
        expect(secondCount).to.be.a('number');
        expect(secondCount).to.be.greaterThan(firstCount);
        expect(secondCount).to.eq(firstCount + 1);
      });
  });

  it('should handle concurrent requests correctly', () => {
    const requests = [];
    
    // Make 5 concurrent requests
    for (let i = 0; i < 5; i++) {
      requests.push(
        cy.request('GET', apiUrl).its('body.count')
      );
    }

    // Verify all requests succeeded and returned valid counts
    cy.wrap(requests).each((requestPromise) => {
      cy.wrap(requestPromise).should('be.a', 'number').and('be.greaterThan', 0);
    });
  });

  it('should respond within acceptable time', () => {
    const startTime = Date.now();
    
    cy.request('GET', apiUrl).then(() => {
      const responseTime = Date.now() - startTime;
      expect(responseTime).to.be.lessThan(3000); // Should respond within 3 seconds
      cy.log(`Response time: ${responseTime}ms`);
    });
  });

  it('should have correct response structure', () => {
    cy.request('GET', apiUrl)
      .its('body')
      .should((body) => {
        expect(body).to.have.all.keys('count');
        expect(body.count).to.be.a('number');
        expect(Number.isInteger(body.count)).to.be.true;
      });
  });

  it('should handle OPTIONS preflight request (CORS)', () => {
    cy.request({
      method: 'OPTIONS',
      url: apiUrl,
      failOnStatusCode: false,
      headers: {
        'Origin': expectedOrigin,
        'Access-Control-Request-Method': 'GET'
      }
    }).then((response) => {
      // Expecting either 200 or 204 for OPTIONS
      expect([200, 204]).to.include(response.status);
    });
  });

  it('should maintain data persistence across requests', () => {
    let initialCount;
    
    // Get initial count
    cy.request('GET', apiUrl)
      .its('body.count')
      .then((count) => {
        initialCount = count;
      });

    // Wait a bit
    cy.wait(1000);

    // Make another request and verify count increased by exactly 1
    cy.request('GET', apiUrl)
      .its('body.count')
      .then((newCount) => {
        expect(newCount).to.eq(initialCount + 1);
      });
  });
});
