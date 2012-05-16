define (require, exports, module) ->
  App = require 'zooniverse/controllers/App'

  LoginForm = require 'zooniverse/controllers/LoginForm'

  seaFloor = new App
    el: '.sea-floor-app'

    authentication: '//localhost:8000/authentication.html'

    projects:
      PSF1234567890:
        name: 'seafloor'
        workflows: {}

    widgets:
      loginForm:
        controller: LoginForm
        attributes:
          el: '.login-form'

  module.exports = seaFloor
