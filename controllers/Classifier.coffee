define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  User = require 'zooniverse/models/User'
  Classification = require 'zooniverse/models/Classification'
  Favorite = require 'zooniverse/models/Favorite'
  {delay} = require 'zooniverse/util'

  Tutorial = require 'zooniverse/controllers/Tutorial'

  class Classifier extends Spine.Controller
    tutorialSteps: null

    template: null

    workflow: null
    tutorial: null
    classification: null

    events: {}
    elements: {}

    constructor: ->
      super
      @html @template if typeof @template is 'string'
      @html @template @ if typeof @template is 'function'

      if @tutorialSteps?.length > 0
        @tutorial = new Tutorial
          target: @el
          steps: @tutorialSteps

      # Delay here so that extending classes can call "super" at
      # the top and not worry about subjects loading immediately.
      delay =>
        @workflow.bind 'change-selection', @reset
        if User.current?.finishedTutorial
          @nextSubjects()
        else
          @startTutorial()

    reset: =>
      @classification?.destroy()

      @classification = Classification.create
        subjects: @workflow.selection

      @classification.bind 'change', @render

      # Delay so extending classes can modify the classification before rendering
      delay => @classification.trigger 'change'

    render: =>
      # Override this.

    startTutorial: (e) =>
      return unless @tutorial?
      e?.preventDefault?()
      @workflow.subjects.unshift subject for subject in @workflow.tutorialSubjects
      @nextSubjects().done @tutorial.start

    saveClassification: =>
      @classification.persist();

    addFavorite: =>
      favorite = Favorite.create subjects: @workflow.selection
      favorite.persist()

    goToTalk: =>
      open @workflow.selection[0].talkHref()

    nextSubjects: =>
      @workflow.nextSubjects()

  module.exports = Classifier
