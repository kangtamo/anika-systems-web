const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    baseUrl: 'https://kangtamo.github.io/anika-systems-web',  // Base URL for the tests
    setupNodeEvents(on, config) {
      // Implement node event listeners if needed
    },
    supportFile: false  // Optional: If you don't want to load support files
  },
  video: false,  // Disable video recording if not needed
  screenshotOnRunFailure: true  // Capture screenshots on failures
});