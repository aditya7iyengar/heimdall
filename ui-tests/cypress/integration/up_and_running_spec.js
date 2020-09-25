//

describe('Up and Running', () => {
  it('visit the root page', () => {
    cy.visit('http://localhost:4000', {
      "headers": {"authorization": "Basic ZGV2X3VzZXI6c2VjcmV0"}
    })
  })
})
