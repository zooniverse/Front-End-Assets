define (require, exports, module) ->
  Spine = require 'Spine'

  config = require 'zooniverse/config'

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
      project.app = @ for project in @projects if @projects?

      @initTopBar()
      @initPagers()
      @initAnalytics()

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
