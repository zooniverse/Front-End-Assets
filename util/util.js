// Generated by CoffeeScript 1.3.1
(function() {

  define(function(require, exports) {
    return exports = {
      delay: function(duration, callback) {
        if (typeof duration === 'function') {
          callback = duration;
          duration = 0;
        }
        return setTimeout(callback, duration);
      },
      limit: function(n, min, max) {
        if (min == null) {
          min = 0;
        }
        if (max == null) {
          max = 1;
        }
        return Math.min(Math.max(min, n), max);
      }
    };
  });

}).call(this);
