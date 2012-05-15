define (require, exports, module) ->
  App = require 'zooniverse/controllers/App'
  SpectrogramClassifier = require 'controllers/SpectrogramClassifier'
  Map = require 'lib/zooniverse/controllers/Map'
  CurrentSubjectInfo = require 'controllers/CurrentSubjectInfo'
  Profile = require 'zooniverse/controllers/Profile'

  batDetective = new App
    el: '.bat-detective-app'

    project:
      id: 'PBD1234567890'

      workflows:
        'WBD1234567890':
          controller: SpectrogramClassifier
          attributes:
            el: '[data-page="classify"] .classifier'

    widgets:
      map:
        controller: Map
        attributes:
          el: '[data-page="home"] .map'
          cartoDB: 'http://example.com/'
          cartoQuery: 'SELECT something FROM somewhere'

      currentSubjectInfo:
        controller: CurrentSubjectInfo
        attributes:
          el: '[data-page="classify"] .current-subject-info'

      profile:
        controller: Profile
        attributes:
          el: '[data-page="profile"]'

  module.exports = batDetective
