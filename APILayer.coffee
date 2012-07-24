define (require, exports, module) ->
  Base = require 'Base'
  {get, post, del, getJSON} = require 'zooniverse/Proxy'

  # These accept objects with IDs or string-IDs.
  idOf = (thing) -> thing?.id || thing

  class APILayer extends Base
    # Each Workflow creates an API layer, so each API works for one workflow.
    workflow: null

    checkCurrent: (andThen...) =>
      getJSON "/projects/#{idOf @workflow.project}/current_user", andThen...

    logIn: ({username, password}, andThen...) ->
      getJSON "/projects/#{idOf @workflow.project}/login", {username, password}, andThen...

    logOut: (andThen...) ->
      getJSON "/projects/#{idOf @workflow.project}/logout", andThen...

    fetchSubjects: ({group, limit}, andThen...) ->
      path = "/projects/#{idOf @workflow.project}"
      path += "/groups/#{idOf group}" if group
      path += "/subjects"
      get path, {limit}, andThen...

    fetchFavorites: ({user}, andThen...) ->
      get "/projects/#{idOf @workflow.project}/users/#{idOf user}/favorites", andThen...

    createFavorite: ({subjects}, andThen...) ->
      path = "/projects/#{idOf @workflow.project}/favorites"
      post path, {favorite: subject_ids: (idOf subject for subject in subjects)}, andThen...

    destroyFavorite: ({favorite}, andThen...) ->
      del "/projects/#{idOf @workflow.project}/favorites/#{idOf favorite}", andThen...

    fetchRecents: ({user}, andThen...) ->
      get "/projects/#{idOf @workflow.project}/users/#{idOf user}/recents", andThen...

    saveClassification: ({subjects, annotations}, andThen...) ->
      path = "/projects/#{idOf @workflow.project}/workflows/#{idOf @workflow.workflow}/classifications"
      subjects = (idOf subject for subject in subjects)
      post path, {classification: {subject_ids: subjects, annotations}}, andThen...

  module.exports = APILayer
