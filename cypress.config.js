const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    specPattern: 'cypress/e2e/**/*.spec.js',
    baseUrl: 'https://kangtamo.github.io/anika-systems-web',  // Base URL for the tests
    setupNodeEvents(on, config) {
      // Implement node event listeners if needed
    },
    reporter: 'mochawesome',
    reporterOptions: {
      overwrite: false, // Whether to overwrite the existing report
      html: false,      // If set to true, generates an HTML report
      json: true,       // If set to true, generates a JSON report
      outputDir: 'cypress/results', // The directory to save the results
    },
    supportFile: false  // Optional: If you don't want to load support files
  },
  video: false,  // Disable video recording if not needed
  screenshotOnRunFailure: true  // Capture screenshots on failures
});