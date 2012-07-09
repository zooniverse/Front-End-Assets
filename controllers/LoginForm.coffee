define (require, exports, module) ->
  Spine = require 'Spine'

  User = require 'zooniverse/models/User'

  template = require 'zooniverse/views/LoginForm'

  class LoginForm extends Spine.Controller
    className: 'zooniverse-login-form'
    template: template

    events:
      'submit .sign-in form': 'onSubmit'
      'click .sign-out button': 'signOut'

    elements:
      '.errors': 'errorsContainer'
      '.sign-in input[name="username"]': 'usernameField'
      '.sign-in input[name="password"]': 'passwordField'
      '.sign-out .current': 'currentDisplay'

    constructor: ->
      super
      @html @template

      User.bind 'sign-in', @onSignIn
      @onSignIn()

    onSubmit: (e) =>
      e.preventDefault()

      @el.removeClass 'has-error'
      @el.addClass 'waiting'
      @errorsContainer.empty()

      auth = User.authenticate
        username: @usernameField.val()
        password: @passwordField.val()

      # Auth errors are specific to the instance,
      # but successes are listened to by all instances.
      auth.fail @onError

    onSignIn: =>
      @el.toggleClass 'signed-in', User.current?
      @el.removeClass 'waiting', User.current?
      @usernameField.add(@passwordField).val ''
      @currentDisplay.html User.current?.name || ''

    onError: (error) =>
      return unless error?
      @el.removeClass 'signed-in'
      @el.removeClass 'waiting'
      @el.addClass 'has-error'

      @errorsContainer.append "<div>#{error}</div>"

    signOut: =>
      User.deauthenticate()

  module.exports = LoginForm
