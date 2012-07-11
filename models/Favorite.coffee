define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  API = require 'zooniverse/API'
  {remove} = require 'zooniverse/util'

  Subject = require 'zooniverse/models/Subject'
  User = require 'zooniverse/models/User'

  class Favorite extends Spine.Module
    @instances: []

    @fromJSON: (raw) ->
      new @
        id: raw.id
        createdAt: raw.created_at
        projectID: raw.project_id
        subjects: (Subject.fromJSON subject for subject in raw.subjects)

    @refresh: =>
      @instances[0].destroy() while @instances.length > 0
      return unless User.current?

      fetch = API["fetch#{@name}s"] project: User.project, user: User.current
      fetch.done (response) =>
        for raw in response
          instance = @fromJSON raw
          instance.projectID = User.project.id || User.project

    id: ''
    createdAt: null
    projectID: 'NO_PROJECT_ID'
    subjects: null

    constructor: (params = {}) ->
      @[property] = value for own property, value of params

      @createdAt ?= new Date
      @subjects ?= []

      @constructor.instances.push @
      User.current?.add favorite: @

    toJSON: =>
      json = {}
      json [@constructor.name.toLowerCase()] =
        subject_ids: (subject.id for subject in @subjects)
      json

    persist: =>
      @trigger 'persisting'

      post = API.createFavorite project: @projectID, favorite: @toJSON()

      post.done (response) =>
        @id = response.id
        @trigger 'persist'

      post.fail (response) =>
        @trigger 'error', response

    destroy: (fromServer) =>
      remove @, from: @constructor.instances

      removeMap = {}
      removeMap[@constructor.name.toLowerCase()] = @
      User.current?.remove removeMap

      if fromServer is true
        API["destroy#{@constructor.name}"] $.extends {project: @projectID}, removeMap

  module.exports = Favorite
