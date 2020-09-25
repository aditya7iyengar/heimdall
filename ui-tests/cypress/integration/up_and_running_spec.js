//

describe('Up and Running', () => {
  it('visits the root page with http basic auth', () => {
    cy.visit('http://localhost:4000', {
     auth: {
        username: 'dev_user',
        password: 'secret'
      }
    })
  })
})
