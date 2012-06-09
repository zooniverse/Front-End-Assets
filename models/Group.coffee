define (require, exports, module) ->
  Spine = require 'spine'

  class Group extends Spine.Model
    @configure 'Group'

  module.exports = Group
