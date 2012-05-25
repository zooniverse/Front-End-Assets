define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  User = require 'zooniverse/models/User'
  Project = require 'zooniverse/models/Project'
  Favorite = require 'zooniverse/models/Favorite'
  Recent = require 'zooniverse/models/Recent'
  Authentication = require 'zooniverse/controllers/Authentication'
  # TopBar = require 'zooniverse/controllers/TopBar'
  Pager = require 'zooniverse/controllers/Pager'

  class App extends Spine.Controller
    languages: null
    projects: null
    widgets: null

    authentication: "https://some.s3.bucket/path/to/auth.html"
    unless location.port is 80
      @::authentication = "//#{location.host}/login-frame/index.html"

    constructor: ->
      super
      @setup()
      # @initTopBar()
      @initPagers()
      @initProjects()
      @initWidgets()

    setup: =>
      # Send cross-origin request headers when logged in.
      $.ajaxSetup beforeSend: (xhr) ->
        if User.current?
          # TODO: Use a proper base-64 encoder.
          # http://stringencoders.googlecode.com/svn/trunk/javascript/base64.js
          auth = btoa "#{User.current.name}:#{User.current.apiKey}"
          xhr.setRequestHeader 'Authorization', "Basic #{auth}"

      Authentication.setSrc @authentication

    initTopBar: =>
      @topBar = new TopBar
        languages: @languages

    initPagers: =>
      for pageContainer in @el.find('[data-page]').parent()
        new Pager el: pageContainer

    initProjects: =>
      for projectId, {attributes, workflows} of @projects
        project = Project.create attributes
        project.updateAttributes id: projectId

        Project.current = project # TODO: Multiple projects?

        for workflowId, {controller, attributes} of workflows
          workflow = new controller attributes
          workflow.id = workflowId

          controller.subject.project = project
          controller.classification.project = project
          controller.classification.workflow = workflow

    initWidgets: =>
      for id, {controller, attributes} of @widgets
        @widgets[id].instance = new controller attributes

  module.exports = App
