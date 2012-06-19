define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  User = require 'zooniverse/models/User'
  Classification = require 'zooniverse/models/Classification'
  Favorite = require 'zooniverse/models/Favorite'
  Recent = require 'zooniverse/models/Recent'
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

      # Delay here so that extending classes can call "super" at
      # the top and not worry about subjects loading immediately.
      # Also give a chance for the workflow to attach itself.
      delay =>
        @workflow.bind 'change-selection', @reset

        if @workflow.tutorialSubjects?.length > 0 and @tutorialSteps?.length > 0
          @tutorial = new Tutorial target: @el, steps: @tutorialSteps

        shouldStartTutorial = @tutorial?

        if @tutorial and not User.current?.finishedTutorial
          @startTutorial()
        else
          @nextSubjects()

    reset: =>
      @classification?.destroy()

      @classification = new Classification
        workflow: @workflow
        subjects: @workflow.selection

      @classification.bind 'change', @render

      # Delay so extending classes can modify the classification before rendering
      delay => @classification.trigger 'change'

    render: =>
      # Override this.

    startTutorial: (e) =>
      e?.preventDefault?()
      @workflow.subjects.unshift subject for subject in @workflow.tutorialSubjects
      @nextSubjects().done @tutorial.start

    saveClassification: =>
      unless @classification.subjects[0].eql @workflow.tutorialSubjects[0]
        @classification.persist()
        Recent.create subjects: @workflow.selection

    addFavorite: =>
      favorite = Favorite.create subjects: @workflow.selection
      favorite.persist()

    goToTalk: =>
      open @workflow.selection[0].talkHref()

    nextSubjects: =>
      @workflow.nextSubjects()

  module.exports = Classifier
