define (require, exports, module) ->
  {get, post, del, getJSON} = require 'zooniverse/Proxy'

  module.exports =
    # Temporary holdovers...
    get: get
    post: post
    del: del
    getJSON: getJSON
    headers: {}

    checkCurrent: ({project}, andThen...) ->
      getJSON "/projects/#{project}/current_user", andThen...

    logIn: ({project, username, password}, andThen...) ->
      getJSON "/projects/#{project}/login", {username, password}, andThen...

    logOut: ({project, username, password}, andThen...) ->
      getJSON "/projects/#{project}/login", {username, password}, andThen...

    fetchSubjects: ({project, group, limit}, andThen...) ->
      path = "/projects/#{project.id || project}"
      path += "/groups/#{group.id || group}" if group
      path += "/subjects"
      get path, {limit}, andThen...

    fetchFavorites: ({project, username}, andThen...) ->
      get "/projects/#{project}/users/#{username}/favorites", andThen...

    saveFavorite: ({project, subjects}, andThen...) ->
      path = "/projects/#{project}/favorites"
      post path, {favorite: subject_ids: subjects}, andThen...

    destroyFavorite: ({project, favorite}, andThen...) ->
      del "/projects/#{project}/favorites/#{favorite}", andThen...

    fetchRecents: ({project, username}, andThen...) ->
      get "/projects/#{project}/users/#{username}/recents", andThen...

    saveClassification: ({project, workflow, subjects, annotations}, andThen...) ->
      path = "/projects/#{project}/workflows/#{workflow}/classifications"
      post path, {classification: {subject_ids: subjects}, annotations}, andThen...
