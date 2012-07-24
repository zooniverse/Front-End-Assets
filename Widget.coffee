define (require, exports, module) ->
  Base = require 'Base'
  $ = require 'jQuery'

  class Widget extends Base
    @_elements: null
    @_delegates: null

    @element: (selector, name) ->
      @ensureUnique Object, '_elements'
      @_elements[selector] = name

    @delegate: (eventString, callback) ->
      @ensureUnique Object, '_delegates'
      @_delegates[eventString] = callback

    tagName: 'div'
    className: ''
    template: ''
    el: null

    eventOptions: esc: 27

    constructor: ->
      super
      @el ?= document.createElement @tagName
      @el = $(@el)
      @el.addClass @className
      @el.html @template @ if typeof @template is 'function'
      @el.html @template if typeof @template is 'string'

      for selector, name of @constructor._elements
        @[name] = @el.find selector

      for eventString, callback of @constructor._delegates
        do (eventString, callback) =>
          # Events are like "keydown!:esc input", where "!" prevents default.
          eventTokens = eventString.match(/^(\w+)(\!?):?(\w*)\s?(.*)/)[1...]
          [eventName, preventDefault, option, selector] = eventTokens
          @el.on eventName, selector, (e) =>
            e.preventDefault() if preventDefault

            if option and eventName.match /^key/
              return unless e.keyCode is @eventOptions[option] || option

            callback = @[callback] if typeof callback is 'string'
            callback.call @, e

  module.exports = Widget
