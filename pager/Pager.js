(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  define(function(require, exports) {
    var $, ACTIVE_CLASS, AFTER_CLASS, BEFORE_CLASS, PAGE_ATTR, Page, Pager, Spine, delay;
    Spine = require('Spine');
    $ = require('jQuery');
    delay = require('util').delay;
    PAGE_ATTR = 'data-page';
    BEFORE_CLASS = 'before';
    ACTIVE_CLASS = 'active';
    AFTER_CLASS = 'after';
    Page = (function(_super) {

      __extends(Page, _super);

      Page.prototype.pager = null;

      Page.prototype.name = '';

      Page.prototype.links = null;

      function Page() {
        this.deactivate = __bind(this.deactivate, this);
        this.activate = __bind(this.activate, this);
        var hash;
        Page.__super__.constructor.apply(this, arguments);
        this.name = this.el.attr(PAGE_ATTR);
        hash = '#' + this.pager.path.replace(':page', this.name);
        this.links = $("a[href=\"" + hash + "\"]");
        this.log("New Page at " + hash + " with " + this.links.length + " links");
      }

      Page.prototype.activate = function() {
        var elAndLinks;
        elAndLinks = this.el.add(this.links);
        elAndLinks.removeClass(BEFORE_CLASS);
        elAndLinks.removeClass(AFTER_CLASS);
        return elAndLinks.addClass(ACTIVE_CLASS);
      };

      Page.prototype.deactivate = function(inactiveClass) {
        var elAndLinks;
        elAndLinks = this.el.add(this.links);
        elAndLinks.removeClass(BEFORE_CLASS);
        elAndLinks.removeClass(AFTER_CLASS);
        elAndLinks.removeClass(ACTIVE_CLASS);
        return elAndLinks.addClass(inactiveClass);
      };

      return Page;

    })(Spine.Controller);
    Pager = (function(_super) {

      __extends(Pager, _super);

      Pager.prototype.pages = null;

      Pager.prototype.path = '';

      function Pager() {
        this.pathMatched = __bind(this.pathMatched, this);
        var _this = this;
        Pager.__super__.constructor.apply(this, arguments);
        this.path = (function() {
          var elPage, parent, segments, _i, _len, _ref;
          segments = [];
          elPage = _this.el.attr(PAGE_ATTR);
          if (elPage) segments.push(elPage);
          _ref = _this.el.parents("[" + PAGE_ATTR + "]");
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            parent = _ref[_i];
            segments.unshift($(parent).attr(PAGE_ATTR));
          }
          segments.push(':page');
          return '/' + segments.join('/');
        })();
        this.pages = (function() {
          var child, _i, _len, _ref, _results;
          _ref = _this.el.children("[" + PAGE_ATTR + "]");
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            child = _ref[_i];
            _results.push(new Page({
              el: child,
              pager: _this
            }));
          }
          return _results;
        })();
        if (typeof this.route === "function") {
          this.route(this.path, this.pathMatched);
        }
        this.log("New Pager at " + this.path + " with " + this.pages.length + " pages");
      }

      Pager.prototype.pathMatched = function(params) {
        var disabledClass, page, _i, _len, _ref, _results;
        if (!params.page) return;
        disabledClass = BEFORE_CLASS;
        _ref = this.pages;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          page = _ref[_i];
          if (page.name === params.page) {
            page.activate();
            _results.push(disabledClass = AFTER_CLASS);
          } else {
            _results.push(page.deactivate(disabledClass));
          }
        }
        return _results;
      };

      return Pager;

    })(Spine.Controller);
    return exports = Pager;
  });

}).call(this);
