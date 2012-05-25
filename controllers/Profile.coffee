define (require, exports, module) ->
  Spine = require 'Spine'

  User = require 'zooniverse/models/User'
  Favorite = require 'zooniverse/models/Favorite'
  Recent = require 'zooniverse/models/Recent'
  Group = require 'zooniverse/models/Group'
  LoginForm = require 'zooniverse/controllers/LoginForm'
  TEMPLATE = require 'zooniverse/views/Profile'
  favoriteTemplate = require 'views/ProfileFavorite'

  class Profile extends Spine.Controller
    className: 'zooniverse-profile'
    template: TEMPLATE

    elements:
      '.login-form': 'loginFormContainer'
      '.favorites ul': 'favoritesList'
      '.recents ul': 'recentsList'
      '.groups ul': 'groupsList'

    constructor: ->
      super
      @html @template

      @loginForm = new LoginForm el: @loginFormContainer

      User.bind 'sign-in', @userChanged
      User.bind 'change', @userChanged

    userChanged: =>
      @el.toggleClass 'signed-in', User.current?

      @favoritesList.empty()
      favorites = Favorite.all() || []
      @el.toggleClass 'has-favorites', favorites.length > 0
      for favorite in favorites
        @favoritesList.append favoriteTemplate favorite

      # recents = User.current?.recents().all() || []
      # @el.toggleClass 'has-recents', recents.length > 0

      # groups = User.current?.groups().all() || []
      # @el.toggleClass 'has-groups', groups.length > 0

  module.exports = Profile
