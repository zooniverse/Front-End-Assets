define (require, exports, module) ->
  Spine = require 'Spine'

  Authentication = require 'zooniverse/controllers/Authentication'
  User = require 'zooniverse/models/User'

  TEMPLATE = require 'zooniverse/views/LoginForm'

  class LoginForm extends Spine.Controller
    className: 'zooniverse-login-form'
    template: TEMPLATE

    events:
      'submit .sign-in form': 'onSubmit'
      'click .sign-out button': 'signOut'

    elements:
      '.errors': 'errors'
      '.sign-in input[name="username"]': 'usernameField'
      '.sign-in input[name="password"]': 'passwordField'
      '.sign-out .current': 'currentDisplay'

    constructor: ->
      super
      @html @template

      User.bind 'sign-in', @onSignIn
      Authentication.bind 'error', @onError

    onSubmit: (e) =>
      @el.removeClass 'has-error'
      @el.addClass 'waiting'
      @errors.empty()
      Authentication.logIn @usernameField.val(), @passwordField.val()
      e.preventDefault()

    onError: (error) =>
      return unless error?
      @el.removeClass 'signed-in'
      @el.removeClass 'waiting'
      @el.addClass 'has-error'
      @errors.html "<div>#{error}</div>"

    onSignIn: =>
      @el.toggleClass 'signed-in', User.current?
      @el.removeClass 'waiting', User.current?
      @usernameField.add(@passwordField).val ''
      @currentDisplay.html User.current?.name || ''

    signOut: =>
      Authentication.logOut()

  module.exports = LoginForm
