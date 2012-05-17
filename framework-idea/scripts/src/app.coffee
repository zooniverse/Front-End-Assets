define (require, exports, module) ->
  App = require 'zooniverse/controllers/App'

  Classifier = require 'controllers/Classifier'
  Subject = require 'models/Subject'

  LoginForm = require 'zooniverse/controllers/LoginForm'

  seaFloor = new App
    el: '.sea-floor-app'

    authentication: '//localhost:8000/authentication.html'

    projects:
      PSF1234567890:
        name: 'seafloor'
        workflows:
          WSF1234567890:
            controller: Classifier
            attributes:
              el: '.classifier'

    widgets:
      loginForm:
        controller: LoginForm
        attributes:
          el: '.login-form'

  module.exports = seaFloor
