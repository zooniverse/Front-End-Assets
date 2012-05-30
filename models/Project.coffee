define (require, exports, module) ->
  Spine = require 'Spine'

  Workflow = require 'zooniverse/models/Workflow'

  class Project extends Spine.Model
    @configure 'Project', 'id', 'host', 'name', 'slug', 'description', 'facebookAppId', 'cartoUser', 'cartoApiKey', 'cartoTable'
    @hasMany 'workflows', Workflow

    current: null

    constructor: ->
      super

      @id ?= 'PROJECT_ID'
      @host ?= 'http://ouroboros.zooniverse.org'
      unless location.port is 80
        @host = "//#{location.hostname}:3000"
      @name ?= 'Zooniverse'
      @slug ?= 'zooniverse'
      @description ?= 'Real Science Online'
      @facebookAppId ?= '310507282327045'

  Workflow.belongsTo 'project', Project

  module.exports = Project
