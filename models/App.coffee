define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  config = require 'zooniverse/config'

  User = require 'zooniverse/models/User'
  Authentication = require 'zooniverse/controllers/Authentication'
  AppController = require 'zooniverse/controllers/App'
  GoogleAnalytics = require 'zooniverse/controllers/GoogleAnalytics'
  Analytics = require 'zooniverse/controllers/Analytics'

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

      @googleAnalytics = new GoogleAnalytics
        account: config.googleAnalytics
        domain: config.domain

      @analytics = new Analytics

  module.exports = App
