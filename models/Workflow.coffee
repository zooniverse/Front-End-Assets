define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  API = require 'zooniverse/API'

  Subject = require 'zooniverse/models/Subject'

  class Workflow extends Spine.Module
    @include Spine.Events

    queueLength: 5 # Number of subjects to have on hand
    selectionLength: 1 # Number of subjects to be classified at a time

    project: null

    subjects: null # Available subjects
    tutorialSubjects: null # Predefined subject for tutorial

    selection: null # Selectedsubjects, removed from main list

    constructor: (params = {}) ->
      @[property] = value for own property, value of params

      @subjects ?= []
      @subjects = [@subjects] unless @subjects instanceof Array

      @tutorialSubjects ?= []
      @tutorialSubjects = [@tutorialSubjects] unless @tutorialSubjects instanceof Array

      subject.workflow = @ for subject in @subjects.concat @tutorialSubjects

      @selection ?= []

    nextSubjects: (group) =>
      @trigger 'changing-selection'
      next = new $.Deferred

      limit = @queueLength - @subjects.length - @selectionLength
      fetch = API.fetchSubjects {@project, group, limit}

      if @subjects.length >= @selectionLength
        @changeSelection()
        next.resolve @selection
      else
        fetch.done (response) =>
          for rawSubject in response
            # Sometimes we get nulls when the database gets screwed up.
            # This shouldn't happen in production.
            continue unless rawSubject?

            subject = Subject.fromJSON rawSubject
            subject.workflow = @
            @subjects.push subject

            # Preload subject images
            src = subject.location.standard
            src ?= subject.location.iamge
            if src
              img = $("<img src='#{src}' />")
              img.css height: 0, opacity: 0, position: 'absolute', width: 0
              img.appendTo 'body'

          @changeSelection()
          next.resolve @selection

      next.promise()

    changeSelection: =>
      if @subjects.length < @selectionLength
        # TODO: Make this nicer.
        alert 'We\'ve run out of subjects for you to classify on this project!'
      else
        @selection = @subjects[...@selectionLength]
        @trigger 'change-selection', @selection

  module.exports = Workflow
