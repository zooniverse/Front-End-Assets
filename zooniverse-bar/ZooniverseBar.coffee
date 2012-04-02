define = window.define or (factory) ->
  getGlobal = (module) -> window[module]
  window.ZooniverseBar = factory getGlobal, null

define (require, exports) ->
	$ = require 'jQuery'

	delay = (duration, callback) ->
		setTimeout callback, duration

	translate = (raw) ->
		if raw.constructor is String
			"<span>#{raw}</span>"
		else
			("<span lang='#{lang}'>#{string}</span>" for lang, string of raw).join ''

	class Menu
		constructor: (options) ->
			@el = $('<ul class="menu"></ul>')
			for option in options
				@el.append option.el
				option.el.addClass 'menu-item'

	class Link
		constructor: (text, href) ->
			@el = $("<li class='link'><a href='#{href}'>#{translate text}</a></li>")

	class Dropdown
		showing: false

		constructor: (heading, content) ->
			@el = $('<li class="dropdown"></li>')

			if heading.constructor is Object
				@el.append "<span class='dropdown-heading'>#{translate heading}</span>"
			else if heading.el?
				@el.append heading.el
				heading.el.addClass 'dropdown-heading'

			@heading = @el.children().first()

			if content.constructor is String
				@el.append "<div class='dropdown-content'>#{content}</div>"
			else if content.el?
				@el.append content.el
				content.el.addClass 'dropdown-content'

			@content = @el.children().last()

			@el.data 'Dropdown', @

			@heading.on 'mouseenter', @show

			@el.on 'mouseleave', =>
				delete @dontHide
				@el.on 'mouseenter', @preventHide
				delay 667, =>
					@el.off 'mouseenter', @preventHide
					@hide() unless @dontHide

			@hide true

		showStyle:
			opacity: 1
			top: '100%'

		show: =>
			@showing = true
			@el.addClass 'open'

			@el.css 'z-index': 1
			@content.css display: ''
			@content.animate @showStyle, 250

		hideStyle:
			opacity: 0
			top: '50%'

		hide: (now) =>
			@showing = false
			@el.removeClass 'open'

			if now then @content.css @hideStyle

			@el.css 'z-index': ''
			@content.animate @hideStyle, 125, =>
				@content.css display: 'none'

		preventHide: =>
			@dontHide = true

	class Accordion
		showing: false

		constructor: (heading, content) ->
			@el = $('<li class="accordion"></li>')

			if heading.constructor is Object
				@el.append "<span class='accordion-heading'>#{translate heading}</span>"
			else if heading.el?
				@el.append heading.el
				heading.el.addClass 'accordion-heading'

			@heading = @el.children().first()

			if content.constructor is String
				@el.append "<div class='accordion-content'>#{content}</div>"
			else if content.el?
				@el.append content.el
				content.el.addClass 'accordion-content'

			@content = @el.children().last()

			@el.data 'Accordion', @

			@heading.on 'click', @onClickHeading

			if @el.hasClass 'open' then @show() else @hide()

		onClickHeading: (e) =>
			for sibling in @el.siblings '.accordion'
				$(sibling).data('Accordion').hide()

			if @showing then @hide() else @show()

		show: =>
			@showing = true
			@el.addClass 'open'

			@content.css height: 'auto'
			naturalHeight = @content.height()
			@content.css height: 0, 250

			@content.animate height: naturalHeight

		hide: =>
			@showing = false
			@el.removeClass 'open'
			@content.animate height: 0, 250

	items =
		home: new Link
			en: 'Zooniverse', de: 'Zooniverse', pl: 'Zooniverse'
			'http://zooniverse.org/'

		languages: new Dropdown
			en: 'EN', de: 'DE', pl: 'PL'
			new Menu [
				new Link 'English', '#language:en'
				new Link 'Deutsch', '#language:de'
				new Link 'Polski', '#language:pl'
			]

		about: new Link
			en: 'About', de: 'About', pl: 'About'
			'http://zooniverse.org/about'

		projects: new Dropdown
			en: 'Projects', de: 'Projects', pl: 'Projects'
			new Menu [
				new Accordion
					en: 'Space', de: 'Space', pl: 'Space'
					new Menu [
						new Link 'Galaxy Zoo: Hubble', '#'
						new Link 'Galaxy Zoo: Mergers', '#'
						new Link 'Galaxy Zoo: Supernovae', '#'
					]
				new Accordion
					en: 'Climate', de: 'Climate', pl: 'Climate'
					new Menu [
						new Link 'Old Weather', '#'
					]
				new Accordion
					en: 'Humanities', de: 'Humanities', pl: 'Humanities'
					new Menu [
						new Link 'Ancient Lives', '#'
					]
				new Accordion
					en: 'Nature', de: 'Nature', pl: 'Nature'
					new Menu [
						new Link 'Whale FM', '#'
					]
			]

		signIn: new Dropdown
			en: 'Sign in', de: 'Sign in', pl: 'Sign in'
		  '''
				<form class="sign-in">
					<div>
						<label>
							<input type="text" name="username" />
							<span class="placeholder">Username</span>
						</label>
					</div>
					<div>
						<label>
							<input type="password" name="password" />
							<span class="placeholder">Password</span>
						</label>
					</div>
					<div class="action">
						<a href="#">Create a new account</a>
						<button type="submit">Sign in</button>
					</div>
				</form>
			'''

	class ZooniverseBar
		@Menu = Menu
		@Link = Link
		@Dropdown = Dropdown
		@Accordion = Accordion

		constructor: (params) ->
			# Defaults
			@leading = ['home', 'languages']
			@trailing = ['about', 'projects', 'signIn']

			$.extend @, params

			@el ||= $('<div></div>')
			@el = $(@el) unless @el.constructor is $
			@el.addClass 'zooniverse-bar'

			for direction in ['leading', 'trailing']
				group = new Menu (items[name] for name in @[direction] when name of items)
				group.el.addClass direction
				@el.append group.el

			defaultLang = @el.closest('[lang]').attr 'lang'
			@el.attr 'lang', defaultLang or 'en'

			@delegateEvents()

		delegateEvents: =>
			@el.on 'click', '[href^="#language:"]', (e) =>
				e.preventDefault()
				@changeLang $(e.target).closest('[href^="#language:"]').attr('href').split(':')[1]

			@el.on 'click', (e) => e.stopPropagation();

			@el.on 'change', (e) =>
				input = $(e.target)

				return if input.attr('type') isnt 'text'

				if input.val()
					input.addClass 'full'
				else
					input.removeClass 'full'

		changeLang: (lang) =>
			$('html').attr 'lang', lang
			@el.attr 'lang', lang

	exports = ZooniverseBar

	# This explicitly for the faux-define function.
	return ZooniverseBar
