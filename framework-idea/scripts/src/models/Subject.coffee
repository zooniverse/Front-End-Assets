define (require, exports, module) ->
  ZooniverseSubject = require 'zooniverse/models/Subject'

  class Subject extends ZooniverseSubject
    @configure 'Subject'
    @queueLength: 5

    @forTutorial: ->
      @create {}

  module.exports = Subject
