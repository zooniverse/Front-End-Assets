define (require, exports, module) ->
  window.zooniverse =
    Workflow: require './Workflow'
    Classifier: require './widgets/Classifier'
    Profile: require './widgets/Profile'

    Base: require './Base'
    Widget: require './Widget'

    User: require './models/User'
    Favorite: require './models/Favorite'
    Recent: require './models/Recent'

  module.exports = window.zooniverse
