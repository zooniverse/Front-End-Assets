define (require, exports, module) ->
  Spine = require 'Spine'

  User = require 'zooniverse/models/User'

  LoginForm = require 'zooniverse/controllers/LoginForm'
  TEMPLATE = require 'zooniverse/views/Profile'

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
      User.bind 'refresh-favorites', @favoritesChanged

    userChanged: =>
      @el.toggleClass 'signed-in', User.current?

      # groups = User.current?.groups().all() || []
      # @el.toggleClass 'has-groups', groups.length > 0

    favoriteTemplate: (favorite) =>
      "<li>#{favorite.createdAt}</li>"

    favoritesChanged: =>
      # TODO: Pagination
      @favoritesList.empty()
      favorites = User.current.favorites
      @el.toggleClass 'has-favorites', favorites.length > 0
      @favoritesList.append @favoriteTemplate favorite for favorite in favorites

    recentTemplate: (recent) =>
      "<li>#{recent.subjects[0].location}</li>"

    recentsChanged: =>
      # @recentsList.empty()
      # recents = User.current?.recents().all() || []
      # @el.toggleClass 'has-recents', recents.length > 0


  module.exports = Profile
