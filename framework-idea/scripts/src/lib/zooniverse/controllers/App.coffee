define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  User = require 'zooniverse/models/User'
  Authentication = require 'zooniverse/controllers/Authentication'
  # TopBar = require 'zooniverse/controllers/TopBar'
  # Pager = require 'zooniverse/controllers/Pager'

  class App extends Spine.Controller
    languages: null
    projects: null
    widgets: null

    authentication: "//#{location.host}/authentication.html"

    constructor: ->
      super
      @setup()
      # @initTopBar()
      # @initPagers()
      # @initProjects()
      @initWidgets()

    setup: =>
      # Send cross-origin request headers when logged in.
      $.ajaxSetup beforeSend: (xhr) ->
        if User.current?
          # TODO: Use a proper base-64 encoder.
          # http://stringencoders.googlecode.com/svn/trunk/javascript/base64.js
          auth = btoa "#{User.current.username}:#{User.current.apiKey}"
          xhr.setRequestHeader 'Authorization', "Basic #{auth}"

      Authentication.setSrc @authentication

    initTopBar: =>
      @topBar = new TopBar
        languages: @languages

    initPagers: =>
      for pageContainer in @el.find('[data-page]').parent()
        new Pager el: pageContainer

    initProjects: =>
      for id, {name, workflows} of @projects
        for id, {controller, attributes} of workflows
          'TODO'

    initWidgets: =>
      for id, {controller, attributes} of @widgets
        @widgets[id].instance = new controller attributes

  module.exports = App
