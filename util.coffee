define (require, exports, module) ->
  days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

  months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ]

  dateWords =
    year: (date) -> "#{date.getUTCFullYear()}"
    y: (date) -> "#{date.getUTCFullYear()}".slice 0, 2
    month: (date) -> months[date.getUTCMonth()]
    m: (date) -> months[date.getUTCMonth()].slice 0, 3
    date: (date) -> "#{date.getUTCDate()}"
    day: (date) -> days[date.getUTCDay()]
    d: (date) -> days[date.getUTCDay()].slice 0, 3
    time24: (date) -> "#{date.getUTCHours()}:#{('0' + date.getUTCMinutes()).slice -2}"
    time12: (date) -> "#{(((date.getUTCHours() % 12) + 12) % 12)}:#{('0' + date.getUTCMinutes()).slice -2}"
    ampm: (date) -> if date.getUTCHours() >= 12 then 'am' else 'pm'

  module.exports =
    delay: (duration, callback) ->
      if typeof duration is 'function'
        callback = duration
        duration = 0

      setTimeout callback, duration

    formatDate: (date, format='(date) (month) (year), (time12) (ampm)') ->
      date = new Date date unless date instanceof Date

      for word, convert of dateWords
        format = format.replace "(#{word})", convert date if ~format.indexOf "(#{word})"

      format
