define (require, exports, module) ->
  Workflow = require 'zooniverse/controllers/Workflow'
  Subject = require 'models/Subject'
  Classification = require 'models/Classification'

  TEMPLATE = require 'views/Classifier'

  class Classifier extends Workflow
    @subject: Subject
    @classification: Classification
    @template: TEMPLATE

    events:
      'click .toggle': 'toggleCoolness'
      'click .next': 'nextSubject'

    elements:
      '.value': 'valueContainer'

    toggleCoolness: =>
      @classification.updateAttributes cool: !@classification.cool

    render: ->
      @valueContainer.html (@classification.cool is true).toString()

  module.exports = Classifier
