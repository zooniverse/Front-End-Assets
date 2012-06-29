define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  {delay, arraysMatch} = require 'zooniverse/util'

  User = require 'zooniverse/models/User'
  Classification = require 'zooniverse/models/Classification'
  Favorite = require 'zooniverse/models/Favorite'
  Recent = require 'zooniverse/models/Recent'

  Tutorial = require 'zooniverse/controllers/Tutorial'
  Dialog = require 'zooniverse/controllers/Dialog'

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
      # TODO: Adding time to the delay so the user has a chance to log in. Not great.
      delay =>
        @workflow.bind 'change-selection', @reset

        if @workflow.tutorialSubjects?.length > 0 and @tutorialSteps?.length > 0
          @tutorial = new Tutorial target: @el, steps: @tutorialSteps

        if @tutorial
          @startTutorial()
        else
          @nextSubjects()

      User.bind 'add-favorite', (user, favorite) =>
        @el.toggleClass 'is-favored', arraysMatch favorite.subjects, @workflow.selection

      User.bind 'remove-favorite', (user, favorite) =>
        @el.toggleClass 'is-favored', not arraysMatch favorite.subjects, @workflow.selection

      User.bind 'sign-in', =>
        if User.current?
          if @tutorial?
            if User.current.finishedTutorial
              @tutorial.end()
              @nextSubjects()
            else
              @startTutorial()
          else
            @nextSubjects()
        else
          @startTutorial()

    reset: =>
      @el.removeClass 'is-favored'

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
      @classification.persist()
      Recent.create subjects: @workflow.selection

    createFavorite: =>
      favorite = Favorite.create subjects: @workflow.selection
      favorite.persist()

    destroyFavorite: =>
      favorite = (fav for fav in User.current.favorites when arraysMatch fav.subjects, @workflow.selection)[0]
      favorite.destroy()

    goToTalk: =>
      if @workflow.selection[0].eql @workflow.tutorialSubjects[0]
        new Dialog
          content: 'Tutorial subjects are not available in Talk at this time.'
          className: 'classifier'
          target: @el
      else
        open @workflow.selection[0].talkHref()

    nextSubjects: =>
      @workflow.nextSubjects()

  module.exports = Classifier
