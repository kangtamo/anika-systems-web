describe('Static Website Tests', () => {
  
    it('Check if all links are valid', () => {
      cy.visit('https://kangtamo.github.io/anika-systems-web');
      cy.get('a').each(link => {
        const href = link.prop('href');
        if (href) {
          cy.request(href).its('status').should('eq', 200);
        }
      });
    });
  
    it('Test on mobile viewports', () => {
      cy.viewport('iphone-x');  // Simulate iPhone X viewport
      cy.visit('https://kangtamo.github.io/anika-systems-web');
      cy.get('body').should('be.visible');  // Ensure the page is rendering correctly
    });
  
    it('Test on tablet viewports', () => {
      cy.viewport('ipad-2');  // Simulate iPad viewport
      cy.visit('https://kangtamo.github.io/anika-systems-web');
      cy.get('body').should('be.visible');
    });
  
    it('Test cross-browser compatibility', () => {
      // Set browser configurations in Cypress config for testing in multiple browsers
    });
  
  });