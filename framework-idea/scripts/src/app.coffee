define (require, exports, module) ->
  App = require 'zooniverse/controllers/App'

  Classifier = require 'controllers/Classifier'
  Subject = require 'models/Subject'

  LoginForm = require 'zooniverse/controllers/LoginForm'

  seaFloor = new App
    el: '.sea-floor-app'

    authentication: '//localhost:8000/login-frame/index.html'

    projects:
      '4fa4088d54558f3d6a000001':
        workflows:
          '4fa408de54558f3d6a000002':
            controller: Classifier
            attributes:
              el: '.classifier'

    widgets:
      loginForm:
        controller: LoginForm
        attributes:
          el: '.login-form'

  module.exports = seaFloor
