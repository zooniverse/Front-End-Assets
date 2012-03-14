(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(function(require, exports) {
    var $, Accordion, Dropdown, Link, Menu, ZooniverseBar, about, home, languages, leading, login, projects, trailing, translate;
    $ = require('jQuery');
    translate = function(raw, href) {
      var lang, out, string;
      out = raw.constructor === String ? "<span>" + raw + "</span>" : ((function() {
        var _results;
        _results = [];
        for (lang in raw) {
          string = raw[lang];
          _results.push("<span lang='" + lang + "'>" + string + "</span>");
        }
        return _results;
      })()).join('');
      if (href != null) out = "<a href='" + href + "'>" + out + "</a>";
      return out;
    };
    Menu = (function() {

      function Menu(options) {
        var option, _i, _len;
        this.el = $("<ul></ul>");
        for (_i = 0, _len = options.length; _i < _len; _i++) {
          option = options[_i];
          this.el.append(option.el);
        }
      }

      return Menu;

    })();
    Link = (function() {

      function Link(text, href) {
        this.el = $("<li>" + (translate(text, href)) + "</li>");
      }

      return Link;

    })();
    Dropdown = (function() {

      function Dropdown(heading, content) {
        this.el = $("<li></li>");
        if (heading.constructor === this.el.append("<span>" + (translate(heading)) + "</span>")) {} else if (heading.el != null) {
          this.el.append(heading.el);
        }
        if (content.constructor === String) {
          this.el.append("<div>" + content + "</div>");
        } else if (content.el != null) {
          this.el.append(content.el);
        }
      }

      return Dropdown;

    })();
    Accordion = (function(_super) {

      __extends(Accordion, _super);

      function Accordion() {
        Accordion.__super__.constructor.apply(this, arguments);
        this.el.addClass('accordion');
      }

      return Accordion;

    })(Dropdown);
    home = new Link({
      en: 'Zooniverse',
      de: 'Zooniverse',
      pl: 'Zooniverse'
    }, 'http://zooniverse.org/');
    languages = new Dropdown({
      en: 'EN',
      de: 'DE',
      pl: 'PL'
    }, new Menu([new Link('English', '#language:en'), new Link('Deutsch', '#language:de'), new Link('Polski', '#language:pl')]));
    about = new Link({
      en: 'About',
      de: 'About',
      pl: 'About'
    }, 'http://zooniverse.org/about');
    projects = new Dropdown({
      en: 'Projects',
      de: 'Projects',
      pl: 'Projects'
    }, new Menu([
      new Accordion({
        en: 'Space',
        de: 'Space',
        pl: 'Space'
      }, new Menu([new Link('Galaxy Zoo: Hubble', '#'), new Link('Galaxy Zoo: Mergers', '#'), new Link('Galaxy Zoo: Supernovae', '#')])), new Accordion({
        en: 'Climate',
        de: 'Climate',
        pl: 'Climate'
      }, new Menu([
        new Link({
          'Old Weather': '#'
        })
      ])), new Accordion({
        en: 'Humanities',
        de: 'Humanities',
        pl: 'Humanities'
      }, new Menu([new Link('Ancient Lives', '#')])), new Accordion({
        en: 'Nature',
        de: 'Nature',
        pl: 'Nature'
      }, new Menu([new Link('Whale FM', '#')]))
    ]));
    login = new Dropdown({
      en: 'Log in',
      de: 'Log in',
      pl: 'Log in'
    }, '<form>TODO</form>');
    leading = new Menu([home, languages]);
    leading.el.addClass('leading');
    trailing = new Menu([about, projects, login]);
    trailing.el.addClass('trailing');
    ZooniverseBar = (function() {

      function ZooniverseBar(params) {
        this.delegateEvents = __bind(this.delegateEvents, this);
        var defaultLang, property, _ref;
        _ref = params || {};
        for (property in _ref) {
          if (!__hasProp.call(_ref, property)) continue;
          this[property] = params[property];
        }
        this.el || (this.el = $('<div></div>'));
        if (this.el.constructor !== $) this.el = $(this.el);
        this.el.addClass('zooniverse-bar');
        this.el.append(leading.el);
        this.el.append(trailing.el);
        defaultLang = this.el.parent('[lang]').attr('lang');
        this.el.attr('lang', defaultLang || 'en');
        this.delegateEvents();
      }

      ZooniverseBar.prototype.delegateEvents = function() {
        var _this = this;
        return this.el.on('click', '[href^="#language:"]', function(e) {
          var lang;
          e.preventDefault();
          lang = $(e.target).parent('[href^="#language:"]').attr('href').split(':')[1];
          return _this.el.attr('lang', lang);
        });
      };

      return ZooniverseBar;

    })();
    return exports = ZooniverseBar;
  });

}).call(this);
