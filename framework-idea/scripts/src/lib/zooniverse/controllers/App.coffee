define (require, exports, module) ->
  Spine = require 'Spine'
  User = require 'zooniverse/models/User'
  $ = require 'jQuery'
  Pager = require 'zooniverse/controllers/Pager'

  class App extends Spine.Controller
    project: null
    workflows: null
    widgets: null

    User: User

    constructor: ->
      super
      @configure()
      @initPagers()
      @initWorkflows()
      @initWidgets()

    configure: =>
      $.ajaxSetup beforeSend: (xhr) ->
        if @User.current?
          # TODO: Use a proper base-64 encoder.
          # http://stringencoders.googlecode.com/svn/trunk/javascript/base64.js
          auth = btoa "#{@User.current.username}:#{@User.current.apiKey}"
          xhr.setRequestHeader 'Authorization', "Basic #{auth}"

    initPagers: =>
      for pager in @el.find('[data-page]').parent()
        new Pager el: pager

    initWorkflows: =>
      for id, {controller, attributes} of @project.workflows
        instance = new controller attributes
        instance.workflowId = id

    initWidgets: =>
      for id, {controller, attributes} of @widgets
        instance = new controller attributes

  module.exports = App
