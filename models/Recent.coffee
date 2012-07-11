define (require, exports, module) ->
  Favorite = require 'zooniverse/models/Favorite'

  ###

  NOTE: This does not work.

  ###

  class Recent extends Favorite
    @instances: []

  module.exports = Recent
