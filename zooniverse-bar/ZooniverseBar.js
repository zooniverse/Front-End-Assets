(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  define(function(require, exports) {
    var Accordion, Dropdown, Link, Menu, Spine, ZooniverseBar, about, home, languages, leading, login, projects, trailing, translate;
    Spine = require('Spine');
    translate = function(raw) {
      var lang, string;
      if (raw.constructor === String) {
        return $("<span>" + raw + "</span>");
      } else {
        return $((function() {
          var _results;
          _results = [];
          for (lang in raw) {
            string = raw[lang];
            _results.push("<span lang='" + lang + "'>string</span>");
          }
          return _results;
        })());
      }
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
        this.el = $("<li><a href='" + href + "'>" + (translate(text)) + "</a></li>");
      }

      return Link;

    })();
    Dropdown = (function() {

      function Dropdown(text, content) {
        this.el = $("<li>" + (translate(text)) + "</li>");
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
    }, new Menu([new Link('English', '#en'), new Link('Deutsch', '#de'), new Link('Polski', '#pl')]));
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
    }, '<form></form>');
    leading = new Menu('', [home, languages]);
    leading.el.addClass('leading');
    trailing = new Menu('', [about, projects, login]);
    trailing.el.addClass('trailing');
    ZooniverseBar = (function() {

      function ZooniverseBar(params) {
        this.el = $('<div></div>');
        this.el.append(leading.el);
        this.el.append(trailing.el);
      }

      return ZooniverseBar;

    })();
    return exports = ZooniverseBar;
  });

}).call(this);
