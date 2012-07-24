define (require, exports, module) ->
  Recent = require 'zooniverse/models/Recent'

  class Favorite extends Recent
    persist: (workflow) =>
      post = workflow.api.createFavorite subjects: @subjects

      post.done (response) =>
        @id = response.id
        @trigger 'persist'

    destroy: (fromServer, workflow) ->
      workflow.api.destroyFavorite @ if fromServer is true
      super

  module.exports = Favorite
