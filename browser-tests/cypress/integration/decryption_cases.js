/*
 * This test file tests decryption functionality of heimdall using cypress
 *
 * To run the file execute the command:
 * $(npm bin)/cypress run --headless --browser chrome
 */

const port = Cypress.env('BIFROST_PORT');
const username = Cypress.env('BIFROST_USER');
const password = Cypress.env('BIFROST_PASSWORD');

describe('Up and Running', () => {
    beforeEach(() => {
        cy.visit(`http://localhost:${port}/encrypted_messages/new`, {
            auth: {
                username: username,
                password: password
            }
        })

        cy.get('textarea[name="encrypted_message[raw_mask]"]').invoke('val', 'Raw value')

        cy.get('textarea[name="encrypted_message[raw]"]').invoke('val', 'Raw value')

        cy.get('input[name="encrypted_message[key]"]').invoke('val', 'secret')

        cy.get('input[name="encrypted_message[short_description]"]').invoke('val', 'other description')

        cy.get('input[name="encrypted_message[max_attempts]"]').invoke('val', 1)
        cy.get('input[name="encrypted_message[max_reads]"]').invoke('val', 100)

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('button[type=submit]').click()

        // On the main page, search for encrypted_message's description
        cy.get('input[type=text]').invoke('val', 'other')

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('form').submit()

        // Visit encrypted_message link
        cy.get('a[class="encrypted_message-link"]', {
            timeout: 1000
        }).first().click()

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)
    })

    it('tests successful decryption an encrypted_message', () => {
        // Decrypt the information
        cy.get('input[type=password]').invoke('val', 'secret')

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('form').submit()

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        // Get button text
        cy.get('button[class="clippy"]', {
            timeout: 1000
        }).should('contain.text', 'Copy to clipboard')
    })

    it('tests unsuccessful decryption an encrypted_message', () => {
        // Try to Decrypt the information with wrong key
        cy.get('input[type=password]').invoke('val', 'bad-secret')

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('form').submit()

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        // Attempts remaining == 0
        cy.get('blockquote').should('contain.text', 'Attempts remaining: 0')
    })
})