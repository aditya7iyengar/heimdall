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

    it('tests the complete life cycle of an encrypted_message', () => {
        cy.visit(`http://localhost:${port}/encrypted_messages/new`, {
            auth: {
                username: username,
                password: password
            }
        })

        cy.get('textarea[name="encrypted_message[raw_mask]"]').invoke('val', 'Raw value')

        cy.get('textarea[name="encrypted_message[raw]"]').invoke('val', 'Raw value')

        cy.get('input[name="encrypted_message[key]"]').invoke('val', 'secret')
        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('input[name="encrypted_message[short_description]"]').invoke('val', 'some description')

        cy.get('button[type=submit]').click()

        // On the main page, search for encrypted_message's description
        cy.get('input[type=text]').invoke('val', 'some')

        cy.get('input[name="encrypted_message[max_attempts]"]').invoke('val', 1)
        cy.get('input[name="encrypted_message[max_reads]"]').invoke('val', 100)

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('form').submit()

        // Visit encrypted_message link
        cy.get('a[class="encrypted-message-link"]', {
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
