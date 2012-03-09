(function() {

  define(function(require, exports) {
    var Spine;
    Spine = require('Spine');
    Spine.Route.originalMatchRoute = Spine.Route.matchRoute;
    Spine.Route.matchRoute = function(path, options) {
      var matchPath, matchedPath, _results;
      if (typeof path === 'string') path = path.split('/');
      matchPath = [];
      _results = [];
      while (path.length > 0) {
        matchPath.push(path.shift());
        matchedPath = matchPath.join('/');
        if (matchedPath) {
          _results.push(this.originalMatchRoute(matchedPath));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };
    Spine.Route.originalChange = Spine.Route.change;
    Spine.Route.change = function() {
      var fragment;
      fragment = Spine.Route.getFragment();
      if (fragment) return Spine.Route.matchRoute(fragment);
    };
    return exports = Spine.Route;
  });

}).call(this);
