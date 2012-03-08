(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  define(function(require, exports) {
    var $, Page, Pager, Spine, delay;
    Spine = require('Spine');
    $ = require('jQuery');
    delay = require('util').delay;
    Page = (function(_super) {

      __extends(Page, _super);

      Page.prototype.path = '';

      Page.prototype.tabs = null;

      function Page() {
        this.deactivate = __bind(this.deactivate, this);
        this.activate = __bind(this.activate, this);
        this.defaultActivate = __bind(this.defaultActivate, this);        Page.__super__.constructor.apply(this, arguments);
        this.tabs || (this.tabs = $("a[href='#" + this.path + "']"));
        this.log("New Page at \"" + this.path + "\" and " + this.tabs.length + " tabs");
        if (this.el.hasClass('active')) delay(this.defaultActivate);
      }

      Page.prototype.defaultActivate = function() {
        if (this.el.hasClass('active')) return this.activate();
      };

      Page.prototype.activate = function() {
        var elAndTabs;
        elAndTabs = this.el.add(this.tabs);
        elAndTabs.addClass('active');
        elAndTabs.removeClass('before');
        return elAndTabs.removeClass('after');
      };

      Page.prototype.deactivate = function(inactiveClass) {
        var elAndTabs;
        elAndTabs = this.el.add(this.tabs);
        elAndTabs.removeClass('active');
        return elAndTabs.addClass(inactiveClass);
      };

      return Page;

    })(Spine.Controller);
    Pager = (function(_super) {

      __extends(Pager, _super);

      Pager.prototype.path = '';

      Pager.prototype.pages = null;

      function Pager() {
        this.pathMatched = __bind(this.pathMatched, this);
        var path,
          _this = this;
        Pager.__super__.constructor.apply(this, arguments);
        this.path || (this.path = (function() {
          var name, segments;
          name = _this.el.attr('data-page');
          segments = [];
          if (name) segments.push(name);
          _this.el.parents('[data-page]').each(function() {
            return segments.unshift($(this).attr('data-page'));
          });
          segments.push(':page');
          return '/' + segments.join('/');
        })());
        path = this.path;
        this.pages || (this.pages = (function() {
          return _this.el.children('[data-page]').map(function() {
            return new Page({
              el: this,
              path: path.replace(':page', $(this).attr('data-page'))
            });
          });
        })());
        this.route(this.path, this.pathMatched);
        this.log("Created new Pager at \"" + this.path + "\" with " + this.pages.length + " pages");
      }

      Pager.prototype.pathMatched = function(params) {
        var matched;
        if (!params.page) return;
        matched = false;
        return this.pages.each(function() {
          if (this.el.attr('data-page') === params.page) {
            matched = true;
            return this.activate();
          } else {
            if (!matched) {
              return this.deactivate('before');
            } else {
              return this.deactivate('after');
            }
          }
        });
      };

      return Pager;

    })(Spine.Controller);
    return exports = Pager;
  });

}).call(this);
