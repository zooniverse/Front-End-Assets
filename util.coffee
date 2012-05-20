define (require, exports, module) ->
  module.exports =
    delay: (duration, callback) ->
      if typeof duration is 'function'
        callback = duration
        duration = 0

      setTimeout callback, duration
