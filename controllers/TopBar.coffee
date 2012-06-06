define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'
  {delay, remove} = require 'zooniverse/util'

  User = require 'zooniverse/models/User'
  LoginForm = require 'zooniverse/controllers/LoginForm'
  template = require 'zooniverse/views/TopBar'

  class TopBar extends Spine.Controller
    @instance: null

    languages: null

    langMap:
      en: 'English'
      po: 'Polski'
      de: 'Deutsche'

    dropdownsToHide: null

    className: 'zooniverse-top-bar'
    template: template

    app: null

    events:
      'mouseenter .z-dropdown': 'onDropdownEnter'
      'mouseleave .z-dropdown': 'onDropdownLeave'
      'click .z-accordion > :first-child': 'onAccordionClick'
      'click .z-languages a': 'changeLanguage'

    elements:
      '.z-languages > :first-child': 'languageLabel'
      '.z-languages :last-child': 'languageList'
      '.z-login > :first-child': 'usernameContainer'
      '.z-login > :last-child': 'loginFormContainer'

    constructor: ->
      return @constructor.instance if @constructor.instance?
      @constructor.instance = @

      super
      @dropdownsToHide = []
      @html @template

      dropdownContainers = @el.find('.z-dropdown').children ':last-child'
      dropdownContainers.css display: 'none', opacity: 0, top: '50%'

      accordionContainers = @el.find '.z-accordion > :last-child'
      accordionContainers.css height: 0, opacity: 0

      @updateLanguages()

      User.bind 'sign-in', @updateLogin
      new LoginForm el: @loginFormContainer

      @updateLogin()

    updateLanguages: =>
      @languageLabel.empty()
      @languageList.empty()
      for lang in @languages
        @languageLabel.append """
          <span lang="#{lang}">#{lang.toUpperCase()}</span>
        """

        @languageList.append """
          <li><a href="##{lang}">#{lang.toUpperCase()} <em>#{@langMap[lang]}</em></a></li>
        """

    updateLogin: =>
      @usernameContainer.html User.current?.name || 'Sign in'

    onDropdownEnter: (e) ->
      target = $(e.currentTarget)
      container = target.children().last()

      remove target, from: @dropdownsToHide

      container.css display: ''
      container.stop().animate opacity: 1, top: '100%'

    onDropdownLeave: (e) ->
      target = $(e.currentTarget)
      container = target.children().last()

      @dropdownsToHide.push target

      delay 500, =>
        return unless target in @dropdownsToHide
        container.stop().animate opacity: 0, top: '50%', =>
          delay => container.css display: 'none'

    onAccordionClick: (e) ->
      target = $(e.currentTarget).parent()
      container = target.children().last()

      closed = container.height() is 0

      if closed
        container.css height: ''

        naturalHeight = container.height()
        container.css height: 0
        container.animate height: naturalHeight, opacity: 1
      else
        container.animate height: 0, opacity: 0

    changeLanguage: (e) ->
      e.preventDefault()
      lang = e.currentTarget.hash.slice -2
      $('html').attr lang: lang

  module.exports = TopBar
