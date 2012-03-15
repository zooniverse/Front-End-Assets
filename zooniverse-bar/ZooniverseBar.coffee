define = window.define or (factory) ->
  getGlobal = (module) -> window[module]
  window.ZooniverseBar = factory getGlobal, null

define (require, exports) ->
	$ = require 'jQuery'

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
		constructor: (heading, content) ->
			@el = $('<li class="dropdown"></li>')
			if heading.constructor is Object
				@el.append "<span class='dropdown-heading'>#{translate heading}</span>"
			else if heading.el?
				@el.append heading.el
				heading.el.addClass 'dropdown-heading'

			if content.constructor is String
				@el.append "<div class='dropdown-content'>#{content}</div>"
			else if content.el?
				@el.append content.el
				content.el.addClass 'dropdown-content'

			@el.children().first().on 'click', @onClickHeading

		onClickHeading: (e) =>
			wasOpen = @el.hasClass 'open'
			@el.closest('.zooniverse-bar').find('.dropdown').removeClass 'open'
			@el.addClass 'open' unless wasOpen

	class Accordion
		constructor: (heading, content) ->
			@el = $('<li class="accordion"></li>')
			if heading.constructor is Object
				@el.append "<span class='accordion-heading'>#{translate heading}</span>"
			else if heading.el?
				@el.append heading.el
				heading.el.addClass 'accordion-heading'

			if content.constructor is String
				@el.append "<div class='accordion-content'>#{content}</div>"
			else if content.el?
				@el.append content.el
				content.el.addClass 'accordion-content'

			@el.children().first().on 'click', @onClickHeading

		onClickHeading: (e) =>
			@el.siblings('.accordion').removeClass 'open'
			@el.toggleClass 'open'


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
							<span>Username</span>
							<input type="text" name="username" />
						</label>
					</div>
					<div>
						<label>
							<span>Password</span>
							<input type="password" name="password" />
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

			@[property] = params[property] for own property of params or {}

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
				lang = $(e.target).closest('[href^="#language:"]').attr('href').split(':')[1]
				@changelang lang
				@closeAllDropdowns()

			@el.on 'click', (e) => e.stopPropagation();
			$(document).on 'click', ':not(.zooniverse-bar *)', @closeAllDropdowns

		changeLang: (lang) =>
			$('html').attr 'lang', lang
			@el.attr 'lang', lang

		closeAllDropdowns: =>
			@el.find('.dropdown.open').removeClass 'open'

	exports = ZooniverseBar

	# This explicitly for the faux-define function.
	return ZooniverseBar
