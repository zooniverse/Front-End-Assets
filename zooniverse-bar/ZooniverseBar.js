(function() {
  var define,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty;

  define = window.define || function(factory) {
    var getGlobal;
    getGlobal = function(module) {
      return window[module];
    };
    return window.ZooniverseBar = factory(getGlobal, null);
  };

  define(function(require, exports) {
    var $, Accordion, Dropdown, Link, Menu, ZooniverseBar, items, translate;
    $ = require('jQuery');
    translate = function(raw) {
      var lang, string;
      if (raw.constructor === String) {
        return "<span>" + raw + "</span>";
      } else {
        return ((function() {
          var _results;
          _results = [];
          for (lang in raw) {
            string = raw[lang];
            _results.push("<span lang='" + lang + "'>" + string + "</span>");
          }
          return _results;
        })()).join('');
      }
    };
    Menu = (function() {

      function Menu(options) {
        var option, _i, _len;
        this.el = $('<ul class="menu"></ul>');
        for (_i = 0, _len = options.length; _i < _len; _i++) {
          option = options[_i];
          this.el.append(option.el);
          option.el.addClass('menu-item');
        }
      }

      return Menu;

    })();
    Link = (function() {

      function Link(text, href) {
        this.el = $("<li class='link'><a href='" + href + "'>" + (translate(text)) + "</a></li>");
      }

      return Link;

    })();
    Dropdown = (function() {

      function Dropdown(heading, content) {
        this.onClickHeading = __bind(this.onClickHeading, this);        this.el = $('<li class="dropdown"></li>');
        if (heading.constructor === Object) {
          this.el.append("<span class='dropdown-heading'>" + (translate(heading)) + "</span>");
        } else if (heading.el != null) {
          this.el.append(heading.el);
          heading.el.addClass('dropdown-heading');
        }
        if (content.constructor === String) {
          this.el.append("<div class='dropdown-content'>" + content + "</div>");
        } else if (content.el != null) {
          this.el.append(content.el);
          content.el.addClass('dropdown-content');
        }
        this.el.children().first().on('click', this.onClickHeading);
      }

      Dropdown.prototype.onClickHeading = function(e) {
        var wasOpen;
        wasOpen = this.el.hasClass('open');
        this.el.closest('.zooniverse-bar').find('.dropdown').removeClass('open');
        if (!wasOpen) return this.el.addClass('open');
      };

      return Dropdown;

    })();
    Accordion = (function() {

      function Accordion(heading, content) {
        this.onClickHeading = __bind(this.onClickHeading, this);        this.el = $('<li class="accordion"></li>');
        if (heading.constructor === Object) {
          this.el.append("<span class='accordion-heading'>" + (translate(heading)) + "</span>");
        } else if (heading.el != null) {
          this.el.append(heading.el);
          heading.el.addClass('accordion-heading');
        }
        if (content.constructor === String) {
          this.el.append("<div class='accordion-content'>" + content + "</div>");
        } else if (content.el != null) {
          this.el.append(content.el);
          content.el.addClass('accordion-content');
        }
        this.el.children().first().on('click', this.onClickHeading);
      }

      Accordion.prototype.onClickHeading = function(e) {
        this.el.siblings('.accordion').removeClass('open');
        return this.el.toggleClass('open');
      };

      return Accordion;

    })();
    items = {
      home: new Link({
        en: 'Zooniverse',
        de: 'Zooniverse',
        pl: 'Zooniverse'
      }, 'http://zooniverse.org/'),
      languages: new Dropdown({
        en: 'EN',
        de: 'DE',
        pl: 'PL'
      }, new Menu([new Link('English', '#language:en'), new Link('Deutsch', '#language:de'), new Link('Polski', '#language:pl')])),
      about: new Link({
        en: 'About',
        de: 'About',
        pl: 'About'
      }, 'http://zooniverse.org/about'),
      projects: new Dropdown({
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
        }, new Menu([new Link('Old Weather', '#')])), new Accordion({
          en: 'Humanities',
          de: 'Humanities',
          pl: 'Humanities'
        }, new Menu([new Link('Ancient Lives', '#')])), new Accordion({
          en: 'Nature',
          de: 'Nature',
          pl: 'Nature'
        }, new Menu([new Link('Whale FM', '#')]))
      ])),
      signIn: new Dropdown({
        en: 'Sign in',
        de: 'Sign in',
        pl: 'Sign in'
      }, '<form class="sign-in">\n	<div>\n		<label>\n			<span>Username</span>\n			<input type="text" name="username" />\n		</label>\n	</div>\n	<div>\n		<label>\n			<span>Password</span>\n			<input type="password" name="password" />\n		</label>\n	</div>\n	<div class="action">\n		<a href="#">Create a new account</a>\n		<button type="submit">Sign in</button>\n	</div>\n</form>')
    };
    ZooniverseBar = (function() {

      ZooniverseBar.Menu = Menu;

      ZooniverseBar.Link = Link;

      ZooniverseBar.Dropdown = Dropdown;

      ZooniverseBar.Accordion = Accordion;

      function ZooniverseBar(params) {
        this.closeAllDropdowns = __bind(this.closeAllDropdowns, this);
        this.delegateEvents = __bind(this.delegateEvents, this);
        var defaultLang, direction, group, name, property, _i, _len, _ref, _ref2;
        _ref = params || {};
        for (property in _ref) {
          if (!__hasProp.call(_ref, property)) continue;
          this[property] = params[property];
        }
        this.el || (this.el = $('<div></div>'));
        if (this.el.constructor !== $) this.el = $(this.el);
        this.el.addClass('zooniverse-bar');
        _ref2 = ['leading', 'trailing'];
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          direction = _ref2[_i];
          group = new Menu((function() {
            var _j, _len2, _ref3, _results;
            _ref3 = this[direction];
            _results = [];
            for (_j = 0, _len2 = _ref3.length; _j < _len2; _j++) {
              name = _ref3[_j];
              if (name in items) _results.push(items[name]);
            }
            return _results;
          }).call(this));
          group.el.addClass(direction);
          this.el.append(group.el);
        }
        defaultLang = this.el.closest('[lang]').attr('lang');
        this.el.attr('lang', defaultLang || 'en');
        this.delegateEvents();
      }

      ZooniverseBar.prototype.delegateEvents = function() {
        var _this = this;
        this.el.on('click', '[href^="#language:"]', function(e) {
          var lang;
          e.preventDefault();
          lang = $(e.target).closest('[href^="#language:"]').attr('href').split(':')[1];
          _this.el.attr('lang', lang);
          return _this.closeAllDropdowns();
        });
        this.el.on('click', function(e) {
          return e.stopPropagation();
        });
        return $(document).on('click', ':not(.zooniverse-bar *)', this.closeAllDropdowns);
      };

      ZooniverseBar.prototype.closeAllDropdowns = function() {
        return this.el.find('.dropdown.open').removeClass('open');
      };

      return ZooniverseBar;

    })();
    exports = ZooniverseBar;
    return ZooniverseBar;
  });

}).call(this);
