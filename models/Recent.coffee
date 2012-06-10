define (require, exports, module) ->
  Spine = require 'Spine'

  Project = require 'zooniverse/models/Project'
  User = require 'zooniverse/models/User'

  class Recent extends Spine.Model
    @configure 'Recent'

    @project: null

  module.exports = Recent
