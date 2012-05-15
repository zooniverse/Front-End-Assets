define (require, exports, module) ->
  Spine = require 'Spine'

  class User extends Spine.Model
    @attributes:
      name: default: 'Anonymous user'
      zooniverseId: default: 'ZOONIVERSE_USER_0'

  module.exports = User
