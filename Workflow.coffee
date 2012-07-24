define (require, exports, module) ->
  Base = require 'zooniverse/Base'
  User = require 'zooniverse/models/User'
  APILayer = require 'zooniverse/APILayer'
  Subject = require 'zooniverse/models/Subject'

  class Workflow extends Base
    name: '' # "Galaxy Zoo"
    domain: '' # "galaxyzoo.org"

    project: '' # "galaxy_zoo"
    id: '' # "GZW1234567890"

    queueLength: 5 # Number of subjects to queue up
    selectionLength: 1 # Number of subjects per classification

    googleAnalytics: '' # "UA-12345678-90" or whatever

    subjects: null # Queue of available subjects
    tutorialSubjects: null # Predefined tutorial subject
    selection: null # Currently selected subjects

    api: null # API layer

    constructor: ->
      super

      @subjects ?= []
      @tutorialSubjects ?= []
      @selection ?= []

      @subjects = [@subjects] unless @subjects instanceof Array
      @tutorialSubjects = [@tutorialSubjects] unless @tutorialSubjects instanceof Array

      @api = new APILayer
        workflow: @

      # @topBar = new TopBar
      #   languages: @languages

      # @topBar.el.prependTo 'body'

      # @initAnalytics()

      User.on 'sign-in', =>
        console.log 'Detected sign in'
        # When a user signs in, they'll need a whole new queue.
        @subjects.pop() until @subjects.length is 0 if User.current?

        @fetchSubjects().done =>
          unless @tutorialSubjects.length is 0 or User.current?.tutorialDone
            @selectTutorial()
          else
            @selectNext()

      # Is anybody logged in?
      User.checkCurrent @

    fetchSubjects: (group) =>
      @trigger 'fetching-subjects'
      @enough = new $.Deferred

      limit = @queueLength - @subjects.length

      # If there are enough subjects in the queue, resolve the deferred immediately.
      if @subjects.length > @selectionLength
        @enough.resolve @subjects

      unless limit is 0
        console.log 'Workflow fetching subjects...',
          'Need:', @queueLength, 'have:', @subjects.length, 'fetching:', limit

        currentSubjectIDs = (subject.id for subject in @subjects)

        fetch = @api.fetchSubjects {group, limit}

        fetch.done (response) =>
          for rawSubject in response
            # Sometimes we get nulls when the database gets screwed up.
            # This shouldn't happen in production.
            continue unless rawSubject?

            # Rarely we can get a subject that's already in the queue.
            # This becomes more common as more subjets are retired.
            # TODO: Re-request subjects to keep the queue full.
            continue if rawSubject.id in currentSubjectIDs

            subject = Subject.deserialize rawSubject
            subject.zoo = @
            @subjects.push subject

            # Preload subject images
            # src = subject.location.standard
            # src ?= subject.location.image
            # if src
            #   img = $("<img src='#{src}' />")
            #   img.css height: 0, opacity: 0, position: 'absolute', width: 0
            #   img.appendTo 'body'

          @trigger 'fetch-subjects', @subjects
          @enough.resolve @subjects unless @enough.isResolved()

      @enough.promise()

    selectNext: =>
      console.log 'Changing subjects selection'
      if @subjects.length > @selectionLength
        @selection = @subjects.splice 0, @selectionLength
        @trigger 'change-selection', @selection
      else
        @trigger 'selection-error', @selection

    selectTutorial: =>
      return unless @tutorialSubjects.length > 0
      console.log 'Prepping tutorial subjects'
      @subjects.unshift @tutorialSubjects...
      @selectNext()
      @trigger 'select-tutorial'

  module.exports = Workflow
