define (require, exports, module) ->
  $ = require 'jQuery'
  {delay} = require 'zooniverse/util'

  class Tutorial
    steps: null
    className: 'tutorial-step'
    controlsClass: 'tutorial-controls'
    arrowClass: 'tutorial-arrow'
    messageClass: 'tutorial-message'
    continueClass: 'tutorial-continue'
    blockerClass: 'tutorial-blocker'

    skipText: '&rarr;'
    skipTitle: 'Skip this step'
    exitText: '&times;'
    exitTitle: 'Exit tutorial'

    el: null
    message: null
    arrow: null

    current = -1

    constructor: ({@steps}) ->
      @steps ?= []

      @el = $("<div class='#{@className}'></div>")

      @controls = $("""
        <div class="#{@controlsClass}">
          <button value="skip" title="#{@skipTitle}">#{@skipText}</button>
          <button value="end" title="#{@exitTitle}">#{@exitText}</button>
        </div>
      """)

      @message = $("<div class='#{@messageClass}'></div>")

      @arrow = $("<div class='#{@arrowClass}'></div>")

      @controls.appendTo @el
      @message.appendTo @el
      @arrow.appendTo @el

      @controls.on 'click', '[value="skip"]', @next
      @controls.on 'click', '[value="end"]', @end

      @el.appendTo $('body')

    start: =>
      @message.css display: ''
      @current = -1
      @next()

    next: (e) =>
      e?.stopPropagation()

      if !!~@current then @steps[@current].leave()

      @current += 1
      if @steps[@current]
        @steps[@current].enter @
      else
        @end()

    end: =>
      @el.css display: 'none'


  class Tutorial.Step
    content: ''
    modal: false
    style: null
    className: ''
    attach: null
    nextOn: null
    continueText: 'Next'
    block: ''

    tutorial: null

    blockers: null

    constructor: ({@content, @style, @attach, @nextOn, @className, @arrowClass, @block}) ->
      @content = [@content] if typeof @content is 'string'
      @content = $(("<p>#{line}<p>" for line in @content).join '') if @content instanceof Array

      @attach.x ?= 'center'
      @attach.y ?= 'middle'
      @attach.at ?= {}
      @attach.at.x ?= 'center'
      @attach.at.y ?= 'middle'

    enter: (@tutorial) =>
      @tutorial.message.html @content

      if @nextOn?
        $(document).on eventName, selector, @tutorial.next for eventName, selector of @nextOn
      else
        buttonsHolder = $("<div class='#{@tutorial.continueClass}'><button>#{@continueText}</button></div>")
        @tutorial.message.append buttonsHolder
        @tutorial.el.on 'click', ".#{@tutorial.continueClass} button", @tutorial.next

      @tutorial.el.css @style if @style
      @tutorial.arrow.addClass @arrowClass if @arrowClass

      delay => @moveMessage @attach.x, @attach.y, @attach.to, @attach.at.x, @attach.at.y if @attach

      @createBlockers()

      @tutorial.el.addClass @className if @className

    moveMessage: (stepX, stepY, target, targetX, targetY) ->
      xStrings = left: 0, center: 0.5, right: 1
      yStrings = top: 0, middle: 0.5, bottom: 1

      stepX = xStrings[stepX] if stepX of xStrings
      stepY = yStrings[stepY] if stepY of yStrings
      targetX = xStrings[targetX] if targetX of xStrings
      targetY = yStrings[targetY] if targetY of yStrings

      target = $(target).first()

      targetSize = width: target.outerWidth(), height: target.outerHeight()
      targetOffset = target.offset()

      stepSize = width: @tutorial.el.outerWidth(), height: @tutorial.el.outerHeight()
      stepOffset =
        left: targetOffset.left - (stepSize.width * stepX) + (targetSize.width * targetX)
        top: targetOffset.top - (stepSize.height * stepY) + (targetSize.height * targetY)

      @tutorial.el.offset stepOffset

    createBlockers: =>
      @blockers = $()

      for element in $(@block)
        element = $(element)

        blocker = $("<div class='#{@tutorial.blockerClass}'></div>")
        blocker.width element.outerWidth()
        blocker.height element.outerHeight()
        blocker.offset element.offset()
        @blockers = @blockers.add blocker

      @blockers.appendTo $('body')
      window.blockers = @blockers

    leave: =>
      @tutorial.message.html ''

      if @nextOn?
        $(document).off eventName, selector, @tutorial.next for eventName, selector of @nextOn
      else
        @tutorial.el.off 'click', ".#{@tutorial.continueClass} button", @tutorial.next

      @tutorial.arrow.removeClass @arrowClass if @arrowClass
      @tutorial.el.removeClass @className if @className

      @blockers.remove()

  module.exports = Tutorial
