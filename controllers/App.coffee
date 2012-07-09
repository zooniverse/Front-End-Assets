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
      console.group 'Constructing app'

      @projects ?= []
      @projects = [@projects] unless @projects instanceof Array
      project.app = @ for project in @projects if @projects?

      @initTopBar()
      @initPagers()
      @initAnalytics()

      console.log 'Finished constructing app'
      User.checkCurrent @projects[0]

      console.groupEnd()

    initTopBar: =>
      console.log 'App: init top bar'
      @topBar = new TopBar languages: @languages
      @topBar.el.prependTo 'body'

    initPagers: =>
      console.log 'App: init pagers'
      for pageContainer in @el.find('[data-page]').parent()
        new Pager el: pageContainer

    initAnalytics: =>
      console.log 'App: init analytics'
      @analytics = new Analytics

      if config.googleAnalytics
        @googleAnalytics = new GoogleAnalytics
          account: config.googleAnalytics
          domain: config.domain

  module.exports = App
