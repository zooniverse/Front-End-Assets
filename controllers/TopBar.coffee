define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'
  {delay} = require 'zooniverse/util'

  LoginForm = require 'zooniverse/controllers/LoginForm'
  template = require 'zooniverse/views/TopBar'

  class TopBar extends Spine.Controller
    @instance: null

    languages: null

    className: 'zooniverse-top-bar'
    template: template

    events:
      'mouseover .dropdown': 'onDropdownOver'
      'mouseout .dropdown': 'onDropdownOut'
      'click .accordion > :first-child': 'onAccordionClick'
      'click .languages a': 'changeLanguage'

    elements:
      '.languages ul': 'languageList'
      '.login .username': 'usernameContainer'
      '.login .form-container': 'loginFormContainer'

    constructor: ->
      return @constructor.instance if @constructor.instance?
      @constructor.instance = @

      super
      @html @template @

      @el.find('.accordion > :last-child').css height: 0

    onDropdownOver: (e) ->
      target = $(e.currentTarget)
      target.addClass 'open'

    onDropdownOut: (e) ->
      target = $(e.currentTarget)
      target.removeClass 'open'

    onAccordionClick: (e) ->
      target = $(e.currentTarget).parent()
      target.toggleClass 'open'
      container = target.children ':last-child'
      closed = container.height() is 0
      console.log container, closed

      if closed
        container.css height: ''
        naturalHeight = container.height()
        container.css height: 0
        container.animate height: naturalHeight
      else
        container.animate height: 0

    changeLanguage: (e) ->
      console.log @, e

  module.exports = TopBar
