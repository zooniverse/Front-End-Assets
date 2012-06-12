define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  User = require 'zooniverse/models/User'
  Authentication = require 'zooniverse/controllers/Authentication'
  AppController = require 'zooniverse/controllers/App'

  class App extends Spine.Model
    @configure 'App', 'languages', 'el', 'controller', 'projects'

    constructor: ->
      super

      @languages ?= ['en']

      @projects ?= []
      project.app = @ for project in @projects if @projects?

      @controller = new AppController
        app: @
        el: @el
        languages: @languages

  module.exports = App
