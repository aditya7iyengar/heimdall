/*
 * This test file tests basic functionality of heimdall using cypress
 *
 * To run the file execute the command:
 * $(npm bin)/cypress run --headless --browser chrome
 */

const port = Cypress.env('BIFROST_PORT');
const username = Cypress.env('BIFROST_USER');
const password = Cypress.env('BIFROST_PASSWORD');

describe('Up and Running', () => {
    it('visits the root page with http basic auth', () => {
        cy.visit(`http://localhost:${port}`, {
            auth: {
                username: username,
                password: password
            }
        })
    })

    it('tests the complete life cycle of an aesir', () => {
        cy.visit(`http://localhost:${port}/aesirs/new`, {
            auth: {
                username: username,
                password: password
            }
        })

        cy.get('input[name="aesir[raw]"]').invoke('val', 'Raw value')

        cy.get('input[name="aesir[key]"]').invoke('val', 'secret')
        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('input[name="aesir[description]"]').invoke('val', 'some description')


        cy.get('button[type=submit]').click()

        // On the main page, search for aesir's description
        cy.get('input[type=text]').invoke('val', 'some')

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('form').submit()

        // Visit aesir link
        cy.get('a[class="aesir-link"]', {
            timeout: 1000
        }).first().click()

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        // Decrypt the information
        cy.get('input[type=password]').invoke('val', 'secret')

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('form').submit()

        // Get button text
        cy.get('button[class="clippy"]', {
            timeout: 1000
        }).should('contain.text', 'Copy to clipboard')
    })
})