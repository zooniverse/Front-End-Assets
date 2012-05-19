define (require, exports, module) ->
  App = require 'zooniverse/controllers/App'

  Classifier = require 'controllers/Classifier'
  Subject = require 'models/Subject'

  Profile = require 'zooniverse/controllers/Profile'

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
        controller: Profile
        attributes:
          el: '.profile'

  window.User = require 'zooniverse/models/User'
  window.Subject = require 'models/Subject'
  window.Classification = require 'models/Classification'

  module.exports = seaFloor
