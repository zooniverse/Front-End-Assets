define (require, exports, module) ->
  $ = require 'jQuery'

  class Tutorial
    steps: null

    className: 'tutorial'
    message: null
    underlay: null

    current = -1

    constructor: ({@el, @steps}) ->
      @steps ?= []

      @underlay = $('<div></div>')
      @underlay.addClass 'underlay'

      @underlay.appendTo @el

      @message = $('<div></div>')
      @message.addClass 'step'

      @message.appendTo @el

    start: =>
      @message.add(@underlay).css display: ''
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
      @message.add(@underlay).css display: 'none'

  class Tutorial.Step
    content: ''
    modal: false
    style: null
    attach: null
    className: ''
    nextOn: ''

    tutorial: null

    constructor: ({@content, @style, @attach, @nextOn, @className}) ->

    enter: (@tutorial) =>
      @tutorial.message.html "<p>#{@content.join('</p><p>')}</p>"

      if @nextOn
        $(document).on eventName, selector, @tutorial.next for eventName, selector of @nextOn
      else
        buttonsHolder = $('<div class="continue"><button>Next</button></div>')
        @tutorial.message.append buttonsHolder
        @tutorial.message.on 'click', '.continue button', @tutorial.next

      @tutorial.message.css @style if @style

      @move @attach.x, @attach.y, @attach.to, @attach.at.x, @attach.at.y if @attach

      @tutorial.message.addClass @className if @className

    move: (stepX, stepY, target, targetX, targetY) ->
      xStrings = left: 0, center: 0.5, right: 1
      yStrings = top: 0, middle: 0.5, bottom: 1

      stepX = xStrings[stepX] if stepX of xStrings
      stepY = yStrings[stepY] if stepY of yStrings
      targetX = xStrings[targetX] if targetX of xStrings
      targetY = yStrings[targetY] if targetY of yStrings

      target = $(target).first()

      targetSize = width: target.width(), height: target.height()
      targetOffset = target.offset()

      stepSize = width: @tutorial.message.width(), height: @tutorial.message.height()
      stepOffset =
        left: targetOffset.left - (stepSize.width * stepX) + (targetSize.width * targetX)
        top: targetOffset.top - (stepSize.height * stepY) + (targetSize.height * targetY)

      @tutorial.message.css stepOffset

    leave: =>
      @tutorial.message.html ''

      if @nextOn
        $(document).off eventName, selector, @tutorial.next for eventName, selector of @nextOn
      else
        @tutorial.message.off 'click', '.continue button', @tutorial.next

      @tutorial.message.removeClass @className if @className

  if module?.exports?
    module.exports = Tutorial
  else
    window.Tutorial = Tutorial
