define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  Tutorial = require 'zooniverse/controllers/Tutorial'

  User = require 'zooniverse/models/User'
  {delay} = require 'zooniverse/util'

  class Workflow extends Spine.Controller
    @subject: null
    @classification: null

    @template: ''

    tutorialSteps: null
    tutorial: null

    classification: null

    constructor: ->
      super
      @html @constructor.template if @constructor.template

      @bindToSubject()

      @tutorial = new Tutorial steps: @tutorialSteps if @tutorialSteps

      isInactive = (i, element) ->
        element = $(element)
        not element.hasClass 'active'

      $(document).on 'pager-activate', =>
        delay (e) =>
          if @el.parents('[data-page]').filter(isInactive).length is 0
            @tutorial.el.show()
          else
            @tutorial.el.hide()

      # Delay here so that extending classes can call "super" at
      # the top and not worry about a Subject loading immediately.
      delay =>
        if User.current?.finishedTutorial
          @nextSubject()
        else
          @startTutorial()

        @constructor.subject.fetch()

    bindToSubject: =>
      @constructor.subject.bind 'fetching', =>
        @el.removeClass 'error'
        @el.addClass 'fetching'

      @constructor.subject.bind 'fetch', =>
        @el.removeClass 'error'
        @el.removeClass 'fetching'

      @constructor.subject.bind 'error', =>
        @el.addClass 'error'
        @el.removeClass 'fetching'

      @constructor.subject.bind 'change-current', @subjectChanged

    subjectChanged: =>
      @classification?.destroy()

      @classification = @constructor.classification.create
        subject: @constructor.subject.current

      @classification.bind 'change', @render
      @classification.trigger 'change'

    startTutorial: =>
      @constructor.subject.setCurrent @constructor.subject.forTutorial()
      delay 1000, @tutorial.start

    saveClassification: =>
      @classification.persist();

    nextSubject: =>
      fetching = @constructor.subject.fetch()
      fetching.done (subjects) =>
        @constructor.subject.setCurrent subjects[0]

    render: =>
      # Override this.

    goToTalk: =>
      @constructor.subject.current.goToTalk()
      @nextSubject()

  module.exports = Workflow
