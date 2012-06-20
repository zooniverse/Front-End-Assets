define (require, exports, module) ->
  Spine = require 'Spine'

  User = require 'zooniverse/models/User'

  LoginForm = require 'zooniverse/controllers/LoginForm'
  TEMPLATE = require 'zooniverse/views/Profile'

  class Profile extends Spine.Controller
    className: 'zooniverse-profile'
    template: TEMPLATE

    events:
      'click .sign-out': 'signOut'

    elements:
      '.username': 'usernameContainer'
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

      if User.current?
        @usernameContainer.html User.current.name
        @updateFavorites()
        @updateRecents()

    favoriteTemplate: (favorite) =>
      "<li>#{favorite.createdAt}</li>"

    updateFavorites: =>
      # TODO: Pagination
      @favoritesList.empty()
      favorites = User.current.favorites
      @el.toggleClass 'has-favorites', favorites.length > 0
      @favoritesList.prepend @favoriteTemplate favorite for favorite in favorites

    recentTemplate: (recent) =>
      "<li>#{recent.subjects[0].location}</li>"

    updateRecents: =>
      @recentsList.empty()
      recents = User.current.recents
      @el.toggleClass 'has-recents', recents.length > 0
      @recentsList.prepend @recentTemplate recent for recent in recents

    signOut: (e) =>
      e.preventDefault()
      User.signOut()

  module.exports = Profile