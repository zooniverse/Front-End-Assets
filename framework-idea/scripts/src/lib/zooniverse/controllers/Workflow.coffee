define (require, exports, module) ->
  Spine = require 'Spine'

  class Workflow extends Spine.Controller
    subject: null

  module.exports = Workflow
