App = require 'zooniverse/controllers/App'
SpectrogramClassifier = require 'controllers/SpectrogramClassifier'
Map = require 'zooniverse/controllers/Map'
CurrentSubjectInfo = require 'controllers/CurrentSubjectInfo'
Profile = require 'controllers/Profile'

# It'll also set up workflow controllers and misc. widgets.
# It also creates nested pages and routes determined by elements with [data-page] attributes.
batDetective = new App
  el: '.bat-detective-app'

  project:
    id: 'PBD1234567890'

    workflows:
      # The SpectrogramClassifier is the main Bat Detective classification UI.
      # It extends zooniverse/controllers/Workflow, which handles stuff like Subject selection.
      # There'll be some basic Workflow controllers included.
      # It's responsible for fetching subjects and pushing out classifications.
      'WBD1234567890':
        controller: SpectrogramClassifier
        attributes:
          el: '[data-page="classify"] .classifier'

  widgets:
    # This is the map on the homepage. It'll show some data from CartoDB.
    map:
      controller: Map
      attributes:
        el: '[data-page="home"] .map'
        cartoDB: 'http://example.com/'
        cartoQuery: 'SELECT something FROM somewhere'

    # This is the info that appears below the classification interface in the field guide.
    currentSubjectInfo:
      controller: CurrentSubjectInfo
      attributes:
        el: '[data-page="classify"] .current-subject-info'

    # The Profile controller displays favorites, recents, and groups.
    # There's probably one in the Zooniverse lib that gets extended per project to show the right info.
    # It requires the User model, which requires the Authentication module, which handles sign-on.
    profile:
      controller: Profile
      attributes:
        el: '[data-page="profile"]'

# Other modules can require this app instance (e.g. if they need the project ID).
module.exports = batDetective

# ====

# Here's one for Sea Floor Explorer off the top of my head:

PhotoClassifier = require 'controllers/PhotoClassifier'
Scoreboard = require 'controllers/Scoreboard'

seaFloor = new App
  el: '.sea-floor-explorer-app'

  project:
    id:'PSF1234567890'

    workflows:
      'WSF1234567890':
        controller: PhotoClassifier
        attributes:
          el: '[data-page="classify"] .classifier'

  widgets:
    homeMap:
      controller: Map
      attributes:
        el: '[data-page="home"] .map'

    scoreboard:
      controller: Scoreboard
      attributes:
        el: '[data-page="home"] .scoreboard'

    profile:
      controller: Profile
      attributes:
        el: '[data-page="profile"]'
