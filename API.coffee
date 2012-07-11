define (require, exports, module) ->
  Proxy = require 'zooniverse/Proxy'
  {get, post, del, getJSON} = Proxy

  module.exports =
    # Temporary holdovers...
    get: get
    post: post
    del: del
    getJSON: getJSON

    Proxy: Proxy

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

    fetchFavorites: ({project, user}, andThen...) ->
      get "/projects/#{project.id || project}/users/#{user.id || user}/favorites", andThen...

    createFavorite: ({project, subjects}, andThen...) ->
      path = "/projects/#{project.id || project}/favorites"
      post path, {favorite: subject_ids: subjects}, andThen...

    destroyFavorite: ({project, favorite}, andThen...) ->
      del "/projects/#{project.id || project}/favorites/#{favorite.id || favorite}", andThen...

    fetchRecents: ({project, user}, andThen...) ->
      get "/projects/#{project.id || project}/users/#{user.id || user}/recents", andThen...

    saveClassification: ({project, workflow, subjects, annotations}, andThen...) ->
      path = "/projects/#{project}/workflows/#{workflow}/classifications"
      post path, {classification: {subject_ids: subjects}, annotations}, andThen...
