const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    env: {
      API_URL: 'https://ramxlm72wb.execute-api.eu-west-2.amazonaws.com/prod'
    },
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
})