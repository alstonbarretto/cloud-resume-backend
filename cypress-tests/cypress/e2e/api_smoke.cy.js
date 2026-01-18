describe("Backend API Smoke Test", () => {
  it("returns a valid counter response", () => {
    const apiUrl = Cypress.env("API_URL")

    expect(apiUrl, "API_URL must be set").to.exist

    cy.request(`${apiUrl}/count`).then((response) => {
      expect(response.status).to.eq(200)
      expect(response.body).to.have.property("count")
      expect(response.body.count).to.be.a("number")
    })
  })
})