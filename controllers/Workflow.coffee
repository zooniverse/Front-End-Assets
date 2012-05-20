define (require, exports, module) ->
  Spine = require 'Spine'

  User = require 'zooniverse/models/User'

  class Workflow extends Spine.Controller
    @subject: null
    @classification: null
    @template: ''

    classification: null

    constructor: ->
      super
      @html @constructor.template if @constructor.template

      @bindToSubject()

      if User.current?.finishedTutorial
        @nextSubject()
      else
        @startTutorial()

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

    nextSubject: =>
      @classification.persist();
      fetching = @constructor.subject.fetch()
      fetching.done (subjects) =>
        @constructor.subject.setCurrent subjects[0]

    render: =>
      # Override this.

  module.exports = Workflow
