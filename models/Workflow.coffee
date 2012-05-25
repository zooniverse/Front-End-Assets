define (require, exports, module) ->
  Spine = require 'Spine'

  class Workflow extends Spine.Model
    @configure 'workflow', 'id'

  module.exports = Workflow
