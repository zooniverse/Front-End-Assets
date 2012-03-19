(function() {
  var define,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

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

      Dropdown.prototype.showing = false;

      function Dropdown(heading, content) {
        this.hide = __bind(this.hide, this);
        this.show = __bind(this.show, this);
        this.onClickHeading = __bind(this.onClickHeading, this);        this.el = $('<li class="dropdown"></li>');
        if (heading.constructor === Object) {
          this.el.append("<span class='dropdown-heading'>" + (translate(heading)) + "</span>");
        } else if (heading.el != null) {
          this.el.append(heading.el);
          heading.el.addClass('dropdown-heading');
        }
        this.heading = this.el.children().first();
        if (content.constructor === String) {
          this.el.append("<div class='dropdown-content'>" + content + "</div>");
        } else if (content.el != null) {
          this.el.append(content.el);
          content.el.addClass('dropdown-content');
        }
        this.content = this.el.children().last();
        this.el.data('Dropdown', this);
        this.heading.on('click', this.onClickHeading);
        this.hide(true);
      }

      Dropdown.prototype.onClickHeading = function(e) {
        var dropdown, _i, _len, _ref;
        _ref = this.el.closest('.zooniverse-bar').find('.dropdown');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          dropdown = _ref[_i];
          if (!this.el.is(dropdown)) $(dropdown).data('Dropdown').hide();
        }
        if (this.showing) {
          return this.hide();
        } else {
          return this.show();
        }
      };

      Dropdown.prototype.showStyle = {
        opacity: 1,
        top: '100%'
      };

      Dropdown.prototype.show = function() {
        this.showing = true;
        this.el.addClass('open');
        this.el.css({
          'z-index': 1
        });
        this.content.css({
          display: ''
        });
        return this.content.animate(this.showStyle, 250);
      };

      Dropdown.prototype.hideStyle = {
        opacity: 0,
        top: '50%'
      };

      Dropdown.prototype.hide = function(now) {
        var _this = this;
        this.showing = false;
        this.el.removeClass('open');
        if (now) this.content.css(this.hideStyle);
        this.el.css({
          'z-index': ''
        });
        return this.content.animate(this.hideStyle, 125, function() {
          return _this.content.css({
            display: 'none'
          });
        });
      };

      return Dropdown;

    })();
    Accordion = (function() {

      Accordion.prototype.showing = false;

      function Accordion(heading, content) {
        this.hide = __bind(this.hide, this);
        this.show = __bind(this.show, this);
        this.onClickHeading = __bind(this.onClickHeading, this);        this.el = $('<li class="accordion"></li>');
        if (heading.constructor === Object) {
          this.el.append("<span class='accordion-heading'>" + (translate(heading)) + "</span>");
        } else if (heading.el != null) {
          this.el.append(heading.el);
          heading.el.addClass('accordion-heading');
        }
        this.heading = this.el.children().first();
        if (content.constructor === String) {
          this.el.append("<div class='accordion-content'>" + content + "</div>");
        } else if (content.el != null) {
          this.el.append(content.el);
          content.el.addClass('accordion-content');
        }
        this.content = this.el.children().last();
        this.el.data('Accordion', this);
        this.heading.on('click', this.onClickHeading);
        if (this.el.hasClass('open')) {
          this.show();
        } else {
          this.hide();
        }
      }

      Accordion.prototype.onClickHeading = function(e) {
        var sibling, _i, _len, _ref;
        _ref = this.el.siblings('.accordion');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          sibling = _ref[_i];
          $(sibling).data('Accordion').hide();
        }
        if (this.showing) {
          return this.hide();
        } else {
          return this.show();
        }
      };

      Accordion.prototype.show = function() {
        var naturalHeight;
        this.showing = true;
        this.el.addClass('open');
        this.content.css({
          height: 'auto'
        });
        naturalHeight = this.content.height();
        this.content.css({
          height: 0
        }, 250);
        return this.content.animate({
          height: naturalHeight
        });
      };

      Accordion.prototype.hide = function() {
        this.showing = false;
        this.el.removeClass('open');
        return this.content.animate({
          height: 0
        }, 250);
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
        this.changeLang = __bind(this.changeLang, this);
        this.delegateEvents = __bind(this.delegateEvents, this);
        var defaultLang, direction, group, name, _i, _len, _ref;
        this.leading = ['home', 'languages'];
        this.trailing = ['about', 'projects', 'signIn'];
        $.extend(this, params);
        this.el || (this.el = $('<div></div>'));
        if (this.el.constructor !== $) this.el = $(this.el);
        this.el.addClass('zooniverse-bar');
        _ref = ['leading', 'trailing'];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          direction = _ref[_i];
          group = new Menu((function() {
            var _j, _len2, _ref2, _results;
            _ref2 = this[direction];
            _results = [];
            for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
              name = _ref2[_j];
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
          e.preventDefault();
          _this.changeLang($(e.target).closest('[href^="#language:"]').attr('href').split(':')[1]);
          return _this.closeAllDropdowns();
        });
        this.el.on('click', function(e) {
          return e.stopPropagation();
        });
        return $(document).on('click', ':not(.zooniverse-bar *)', this.closeAllDropdowns);
      };

      ZooniverseBar.prototype.changeLang = function(lang) {
        $('html').attr('lang', lang);
        return this.el.attr('lang', lang);
      };

      ZooniverseBar.prototype.closeAllDropdowns = function() {
        var dropdown, _i, _len, _ref, _results;
        _ref = this.el.find('.dropdown');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          dropdown = _ref[_i];
          _results.push($(dropdown).data('Dropdown').hide());
        }
        return _results;
      };

      return ZooniverseBar;

    })();
    exports = ZooniverseBar;
    return ZooniverseBar;
  });

}).call(this);
