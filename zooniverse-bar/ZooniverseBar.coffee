define (require, exports) ->
	$ = require 'jQuery'

	translate = (raw, href) ->
		out = if raw.constructor is String
			"<span>#{raw}</span>"
		else
			("<span lang='#{lang}'>#{string}</span>" for lang, string of raw).join ''

		out = "<a href='#{href}'>#{out}</a>" if href?

		out

	class Menu
		constructor: (options) ->
			@el = $("<ul></ul>")
			@el.append option.el for option in options

	class Link
		constructor: (text, href) ->
			@el = $("<li>#{translate text, href}</li>")

	class Dropdown
		constructor: (heading, content) ->
			@el = $("<li></li>")
			if heading.constructor is
				@el.append "<span>#{translate heading}</span>"
			else if heading.el?
				@el.append heading.el

			if content.constructor is String
				@el.append "<div>#{content}</div>"
			else if content.el?
				@el.append content.el

	class Accordion extends Dropdown
		constructor: ->
			super
			@el.addClass 'accordion'


	home = new Link
		en: 'Zooniverse', de: 'Zooniverse', pl: 'Zooniverse'
		'http://zooniverse.org/'

	languages = new Dropdown
		en: 'EN', de: 'DE', pl: 'PL'
		new Menu [
			new Link 'English', '#language:en'
			new Link 'Deutsch', '#language:de'
			new Link 'Polski', '#language:pl'
		]

	about = new Link
		en: 'About', de: 'About', pl: 'About'
		'http://zooniverse.org/about'

	projects = new Dropdown
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
					new Link 'Old Weather': '#'
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

	login = new Dropdown
		en: 'Log in', de: 'Log in', pl: 'Log in'
	  '''
			<form>TODO</form>
		'''

	leading = new Menu [home, languages]
	leading.el.addClass 'leading'

	trailing = new Menu [about, projects, login]
	trailing.el.addClass 'trailing'


	class ZooniverseBar
		constructor: (params) ->
			@[property] = params[property] for own property of params or {}

			@el ||= $('<div></div>')
			@el = $(@el) unless @el.constructor is $
			@el.addClass 'zooniverse-bar'

			@el.append leading.el
			@el.append trailing.el

			defaultLang = @el.parent('[lang]').attr 'lang'
			@el.attr 'lang', defaultLang or 'en'

			@delegateEvents()

		delegateEvents: =>
			@el.on 'click', '[href^="#language:"]', (e) =>
				e.preventDefault()
				lang = $(e.target).parent('[href^="#language:"]').attr('href').split(':')[1]
				@el.attr 'lang', lang

	exports = ZooniverseBar
