define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  config = require 'zooniverse/config'
  {delay} = require 'zooniverse/util'

  Subject = require 'zooniverse/models/Subject'

  class Workflow extends Spine.Model
    # Belongs to a project, has many subjects
    @configure 'Workflow', 'devID', 'queueLength', 'selectionLength', 'tutorialSubjects', 'project', 'subjects'

    queueLength: 5
    selectionLength: 1
    selection: null

    constructor: ->
      super

      @id = @devID if config.dev

      @tutorialSubjects ?= []
      @subjects ?= []
      subject.workflow = @ for subject in @tutorialSubjects

      @controller?.workflow = @

    fetchSubjects: (group) =>
      fetch = new $.Deferred
      groupSegment = ''
      groupSegment = '/#{group}' if group

      url = """
        #{config.apiHost}
        /projects/#{@project.id}
        #{groupSegment}
        /subjects?limit=#{@queueLength - @subjects.length}
      """.replace /\n/g, ''

      get = $.getJSON url

      get.done (response) =>
        for raw in response
          continue unless raw # TODO: Why am I getting some nulls back?
          subject = Subject.fromJSON raw
          subject.workflow = @
          @subjects.push subject

          if subject.location.standard
            img = $("<img src='#{subject.location.standard}' />")
            img.css
              height: 0
              opacity: 0
              position: 'absolute'
              width: 0
            img.appendTo 'body'

        fetch.resolve @subjects

      get.fail (response) =>
        fetch.reject response

      fetch.promise()

    nextSubjects: =>
      fetch = @fetchSubjects()
      next = new $.Deferred

      if @subjects.length >= @selectionLength
        @changeSelection()
        next.resolve @selection
      else
        fetch.done =>
          @changeSelection()
          next.resolve @selection

      next

    changeSelection: =>
      if @subjects.length < @selectionLength
        alert 'We\'ve run out of subjects for you to classify on this project!'
        throw new Error 'No more subjects'

      @selection = @subjects.splice 0, @selectionLength
      @trigger 'change-selection'

  module.exports = Workflow
