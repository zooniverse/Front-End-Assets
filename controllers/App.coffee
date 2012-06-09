define (require, exports, module) ->
  Spine = require 'spine'

  Project = require 'zooniverse/models/Project'

  TopBar = require 'zooniverse/controllers/TopBar'
  Pager = require 'zooniverse/controllers/Pager'

  class App extends Spine.Controller
    app: null # Model
    languages: null

    constructor: ->
      super
      @initTopBar()
      @initPagers()

    initTopBar: =>
      @topBar = new TopBar
        languages: @languages

      @topBar.el.appendTo 'body'

    initPagers: =>
      for pageContainer in @el.find('[data-page]').parent()
        new Pager el: pageContainer

  module.exports = App
