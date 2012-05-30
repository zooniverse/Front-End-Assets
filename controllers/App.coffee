define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  User = require 'zooniverse/models/User'
  Authentication = require 'zooniverse/controllers/Authentication'
  Project = require 'zooniverse/models/Project'

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
      $.ajaxSetup beforeSend: (xhr, settings) ->
        if User.current? and !!~settings.url.indexOf Project.current.host
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
      for projectID, {attributes, workflows} of @projects
        project = Project.create attributes
        project.updateAttributes id: projectID

        Project.current = project

        for workflowID, {subject, classification, controller, attributes} of workflows
          workflow = project.workflows().create attributes
          workflow.updateAttributes id: workflowID

          subject.workflow = workflow
          controller.subject = subject

          classification.workflow = workflow
          controller.classification = classification

          controllerInstance = new controller attributes

    initWidgets: =>
      for id, {controller, attributes} of @widgets
        @widgets[id].instance = new controller attributes

  module.exports = App
