define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jquery'

  Route = require 'zooniverse/controllers/Route'
  {delay} = require 'zooniverse/util'

  PAGE_ATTR = 'data-page'

  BEFORE_CLASS = 'before'
  ACTIVE_CLASS = 'active'
  AFTER_CLASS = 'after'

  class Page extends Spine.Controller
    pager: null

    name: ''
    links: null

    constructor: ->
      super

      @name = @el.attr PAGE_ATTR

      hash = '#!' + @pager.path.replace ':page', @name
      @links = $("a[href=\"#{hash}\"]")

      # console.log "New Page at #{hash} with #{@links.length} links"

    activate: =>
      elAndLinks = @el.add @links
      elAndLinks.removeClass BEFORE_CLASS
      elAndLinks.removeClass AFTER_CLASS
      elAndLinks.addClass ACTIVE_CLASS

      @el.trigger 'pager-activate'

    deactivate: (inactiveClass) =>
      elAndLinks = @el.add @links
      elAndLinks.removeClass BEFORE_CLASS
      elAndLinks.removeClass AFTER_CLASS
      elAndLinks.removeClass ACTIVE_CLASS
      elAndLinks.addClass inactiveClass

      @el.trigger 'pager-deactivate'

  class Pager extends Spine.Controller
    pages: null
    path: '' # Like "/foo/bar/:page"

    constructor: ->
      super

      @path = do =>
        segments = []

        # A pager might be a page itself, so include it in the path.
        elPage = @el.attr PAGE_ATTR
        if elPage then segments.push elPage

        for parent in @el.parents("[#{PAGE_ATTR}]")
          segments.unshift $(parent).attr PAGE_ATTR

        segments.push ':page'

        '/' + segments.join '/'

      @pages = do =>
        for child in @el.children "[#{PAGE_ATTR}]"
          new Page
            el: child
            pager: @

      page.activate() for page in @pages when page.el.hasClass 'active'

      @route = new Route @path, @pathMatched

      # console.log "New Pager at #{@path} with #{@pages.length} pages"

    pathMatched: (pageName) =>
      disabledClass = BEFORE_CLASS
      for page in @pages
        if page.name == pageName
          page.activate()
          disabledClass = AFTER_CLASS
        else
          page.deactivate disabledClass

  module.exports = Pager
