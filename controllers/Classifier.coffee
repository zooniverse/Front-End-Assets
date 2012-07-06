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

      if @workflow.tutorialSubjects?.length > 0 and @tutorialSteps?.length > 0
        @tutorial = new Tutorial target: @el, steps: @tutorialSteps

      User.bind 'sign-in', =>
        if @tutorial?
          if User.current?.tutorialDone
            @tutorial.end()
            @nextSubjects()
          else
            @startTutorial()
        else
          @nextSubjects()

        @updateFavoriteButtons()

      User.bind 'add-favorite', (user, favorite) =>
        @el.toggleClass 'is-favored', arraysMatch favorite.subjects, @workflow.selection

      User.bind 'remove-favorite', (user, favorite) =>
        @el.toggleClass 'is-favored', not arraysMatch favorite.subjects, @workflow.selection

      @workflow.bind 'change-selection', @reset

    reset: =>
      @el.removeClass 'is-favored'
      @updateFavoriteButtons()

      @classification?.destroy()

      @classification = new Classification
        workflow: @workflow
        subjects: @workflow.selection

      @classification.bind 'change', @render

      # Delay so extending classes can modify the classification before rendering
      delay => @classification.trigger 'change'

    updateFavoriteButtons: =>
      signedIn = User.current?

      if @workflow.tutorialSubjects instanceof Array
        tutorial = arraysMatch @workflow.selection, @workflow.tutorialSubjects
      else
        tutorial = false

      @el.toggleClass 'can-favorite', signedIn and not tutorial

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
