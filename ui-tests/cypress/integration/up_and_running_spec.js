/*
 * This test file tests basic functionality of heimdall using cypress
 *
 * To run the file execute the command:
 * $(npm bin)/cypress run --headless --browser chrome
 */

describe('Up and Running', () => {
  it('visits the root page with http basic auth', () => {
    cy.visit('http://localhost:4000', {
     auth: {
        username: 'dev_user',
        password: 'secret'
      }
    })
  })

  it('tests the complete life cycle of an aesir', () => {
    cy.visit('http://localhost:4000/aesirs/new', {
     auth: {
        username: 'dev_user',
        password: 'secret'
      }
    })

    cy.get('input[name="aesir[raw]"]').invoke('val', 'Raw value')
    cy.get('input[name="aesir[key]"]').invoke('val', 'secret')
    cy.get('input[name="aesir[description]"]').invoke('val', 'some description')
    cy.get('button[type=submit]').click()

    // On the main page, search for aesir's description
    cy.get('input[type=text]').invoke('val', 'some')
    // Give a few milliseconds for the websocket to do its magic
    cy.wait(10)
    cy.get('form').submit()

    // Visit aesir link
    cy.get('a[class="aesir-link"]').first().click()

    // Decrypt the information
    cy.get('input[type=password]').invoke('val', 'secret')
    // Give a few milliseconds for the websocket to do its magic
    cy.wait(10)
    cy.get('form').submit()
    cy.get('button').should('contain.text', 'Copy to clipboard')
  })
})
