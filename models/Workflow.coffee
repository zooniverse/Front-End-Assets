define (require, exports, module) ->
  Spine = require 'Spine'

  Classification = require 'zooniverse/models/Classification'

  class Workflow extends Spine.Model
    @configure 'workflow', 'id'
    @hasMany 'classifications', Classification

  Classification.belongsTo 'workflow', Workflow

  module.exports = Workflow
