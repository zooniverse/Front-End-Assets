define (require, exports, module) ->
  Spine = require 'Spine'

  class Subject extends Spine.Model
    @setWorkflow: (id) ->

  module.exports = Subject
