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
        cy.visit(`http://localhost:${port}/aesirs/new`, {
            auth: {
                username: username,
                password: password
            }
        })

        cy.get('textarea[name="aesir[raw_mask]"]').invoke('val', 'Raw value')

        cy.get('input[name="aesir[key]"]').invoke('val', 'secret')
        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('input[name="aesir[description]"]').invoke('val', 'other description')

        cy.get('input[name="aesir[max_attempts]"]').invoke('val', 1)

        cy.get('button[type=submit]').click()

        // On the main page, search for aesir's description
        cy.get('input[type=text]').invoke('val', 'other')

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('form').submit()

        // Visit aesir link
        cy.get('a[class="aesir-link"]', {
            timeout: 1000
        }).first().click()

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)
    })

    it('tests successful decryption an aesir', () => {
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

    it('tests unsuccessful decryption an aesir', () => {
        // Try to Decrypt the information with wrong key
        cy.get('input[type=password]').invoke('val', 'bad-secret')

        // Give a few milliseconds for the websocket to do its magic
        cy.wait(100)

        cy.get('form').submit()

        // Get button text
        cy.get('blockquote').should('contain.text', 'Decryption attempts remaining: 0')
    })
})
