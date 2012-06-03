define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'
  Subject = require './Subject'

  class Workflow extends Spine.Model
    # Belongs to a project, has many subjects
    @configure 'Workflow', 'controller', 'project', 'subjects', 'tutorialSubjects'

    queueLength: 5
    selectionLength: 1
    selection: null

    constructor: ->
      super

      @controller?.workflow = @
      @subjects ?= []
      @tutorialSubjects ?= []

      subject.workflow = @ for subject in @tutorialSubjects

    fetchSubjects: (group) =>
      fetch = new $.Deferred
      groupSegment = ''
      groupSegment = '/#{group}' if group

      url = """
        #{@project.app.host}
        /projects/#{@project.id}
        #{groupSegment}
        /subjects?limit=#{@queueLength - @subjects.length}
      """.replace '\n', '', 'g'

      get = $.getJSON url

      get.done (response) =>
        for raw in response
          subject = Subject.fromJSON raw
          subject.workflow = @
          @subjects.push subject

        fetch.resolve @subjects

      fetch.promise()

    nextSubjects: =>
      fetch = @fetchSubjects()

      if @subjects.length >= @selectionLength
        @changeSelection()
      else
        fetch.done @changeSelection

    changeSelection: =>
      if @subjects.length < @selectionLength
        alert 'We\'ve run out of subjects for you to classify on this project!'
        throw new Error 'No more subjects'
      @selection = @subjects.splice 0, @selectionLength
      @trigger 'change-selection'

  # When a subject is created from JSON, its workflow is just an ID.
  Subject.bind 'from-json', (subject) =>
    if typeof subject.workflow is 'string'
      subject.workflow = Workflow.find subject.workflow
      subject.save()

  module.exports = Workflow
