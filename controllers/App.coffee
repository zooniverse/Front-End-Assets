define (require, exports, module) ->
  Spine = require 'Spine'

  config = require 'zooniverse/config'
  {delay} = require 'zooniverse/util'

  User = require 'zooniverse/models/User'
  TopBar = require 'zooniverse/controllers/TopBar'
  Pager = require 'zooniverse/controllers/Pager'
  GoogleAnalytics = require 'zooniverse/controllers/GoogleAnalytics'
  Analytics = require 'zooniverse/controllers/Analytics'

  class App extends Spine.Controller
    languages: null # Array like ['en', 'po'] passed to TopBar
    projects: null # Array of Project model instances

    analytics: null
    googleAnalytics: null

    constructor: ->
      super

      @projects ?= []
      @projects = [@projects] unless @projects instanceof Array
      for project in @projects
        project.app = @
        project.save()

      @initTopBar()
      @initPagers()
      @initAnalytics()

      User.checkCurrent(@projects[0]).done (response) =>
        console.log 'Current user', response

    initTopBar: =>
      @topBar = new TopBar languages: @languages
      @topBar.el.prependTo 'body'

    initPagers: =>
      for pageContainer in @el.find('[data-page]').parent()
        new Pager el: pageContainer

    initAnalytics: =>
      @analytics = new Analytics

      if config.googleAnalytics
        @googleAnalytics = new GoogleAnalytics
          account: config.googleAnalytics
          domain: config.domain

  module.exports = App
