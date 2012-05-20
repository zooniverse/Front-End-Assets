define (require, exports, module) ->
  Spine = require 'Spine'

  User = require 'zooniverse/models/User'
  TEMPLATE = require 'zooniverse/views/Profile'
  LoginForm = require 'zooniverse/controllers/LoginForm'

  class Profile extends Spine.Controller
    className: 'zooniverse-profile'
    template: TEMPLATE

    favoriteTemplate: ''
    recentTemplate: ''
    groupTemplate: ''

    elements:
      '.login-form': 'loginFormContainer'
      '.favorites ul': 'favoritesList'
      '.recents ul': 'recentsList'
      '.groups ul': 'groupsList'

    constructor: ->
      super
      @html @template
      @favoriteTemplate = @favoritesList.html()
      @recentTemplate = @recentsList.html()
      @groupTemplate = @groupsList.html()

      @loginForm = new LoginForm el: @loginFormContainer

      User.bind 'sign-in', @userChanged

    userChanged: =>
      @el.toggleClass 'signed-in', User.current?

      favorites = User.current?.favorites().all() || []
      @el.toggleClass 'has-favorites', favorites.length > 0

      recents = User.current?.recents().all() || []
      @el.toggleClass 'has-recents', recents.length > 0

      groups = User.current?.groups().all() || []
      @el.toggleClass 'has-groups', groups.length > 0

  module.exports = Profile
