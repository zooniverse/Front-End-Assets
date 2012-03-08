(function() {

  define(function(require, exports) {
    var Spine;
    Spine = require('Spine');
    Spine.Route.superMatchRoute = Spine.Route.matchRoute;
    Spine.Route.matchRoute = function(path, options) {
      var matchPath, matchedPath, _results;
      if (typeof path === 'string') path = path.split('/');
      matchPath = [];
      _results = [];
      while (path.length > 0) {
        matchPath.push(path.shift());
        matchedPath = matchPath.join('/');
        if (matchedPath) {
          _results.push(this.superMatchRoute(matchedPath));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };
    return exports = Spine.Route;
  });

}).call(this);
