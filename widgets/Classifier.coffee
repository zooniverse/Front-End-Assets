define (require, exports, module) ->
  Widget = require 'zooniverse/Widget'
  Workflow = require 'zooniverse/Workflow'
  Tutorial = require 'zooniverse/widgets/Tutorial'
  User = require 'zooniverse/models/User'
  {arraysMatch, delay} = require 'zooniverse/util'
  Classification = require 'zooniverse/models/Classification'
  Favorite = require 'zooniverse/models/Favorite'
  Recent = require 'zooniverse/models/Recent'
  Dialog = require 'zooniverse/widgets/Dialog'

  class Classifier extends Widget
    workflow: null
    tutorialSteps: null
    tutorial: null
    classification: null

    className: 'classifier'

    constructor: ->
      super

      @workflow ?= Workflow.instances[0]

      if @workflow.tutorialSubjects?.length > 0 and @tutorialSteps?.length > 0
        @tutorial = new Tutorial target: @el, steps: @tutorialSteps

      @workflow.on 'change-selection', @selectionChanged

      @workflow.on 'selection-error', @noMoreSubjects

      @workflow.on 'select-tutorial', @tutorialSelected

      User.on 'add-favorite', (user, favorite) =>
        if arraysMatch favorite.subjects, @workflow.selection
          @el.addClass 'is-favored'

      User.on 'remove-favorite', (user, favorite) =>
        if arraysMatch favorite.subjects, @workflow.selection
          @el.removeClass 'is-favored'

      # Delay so extending classes can set up their UIs.
      delay =>
        @selectionChanged() if User.currentChecked

    selectionChanged: =>
      @tutorial?.end()

      @el.removeClass 'show-summary'
      @el.removeClass 'is-favored'

      signedIn = User.current?

      if @workflow.tutorialSubjects?
        tutorialSubject = arraysMatch @workflow.selection, @workflow.tutorialSubjects

      @el.toggleClass 'can-favorite', signedIn and not tutorialSubject

      @classification?.destroy()
      @classification = new Classification
        zoo: @workflow
        subjects: @workflow.selection

      @classification.on 'change', @render

      # Delay so extending classes can set defaults
      # on the classification before rendering.
      delay =>
        @classification.trigger 'change'

    render: =>
      # Override this.

    startTutorial: (e) =>
      @workflow.selectTutorial()

    tutorialSelected: =>
      @tutorial?.start()

    saveClassification: =>
      @classification.persist()
      new Recent subjects: @workflow.selection
      @el.addClass 'show-summary'

    createFavorite: =>
      favorite = new Favorite
        subjects: @workflow.selection
        projectID: @workflow.project.id

      favorite.persist @workflow

    destroyFavorite: =>
      favorite = (fav for fav in User.current.favorites when arraysMatch fav.subjects, @workflow.selection)[0]
      console.log 'Destroying favorite', favorite
      favorite.destroy true, @workflow

    goToTalk: =>
      if arraysMatch @workflow.selection, @workflow.tutorialSubjects
        new Dialog
          content: 'Tutorial subjects are not available in Talk at this time.'
          className: 'classifier'
          target: @el
      else
        open @workflow.selection[0].talkHREF()

    nextSubjects: =>
      @workflow.fetchSubjects().done =>
        @workflow.selectNext()

    noMoreSubjects: =>
      alert 'We\'ve run out of subjects for you!' # TODO: Make this much nicer.

  module.exports = Classifier
