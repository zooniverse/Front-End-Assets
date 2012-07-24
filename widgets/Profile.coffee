define (require, exports, module) ->
  Widget = require 'zooniverse/Widget'
  $ = require 'jQuery'
  {delay} = require 'zooniverse/util'
  User = require 'zooniverse/models/User'
  Recent = require 'zooniverse/models/Recent'
  Favorite = require 'zooniverse/models/Favorite'

  # LoginForm = require 'zooniverse/controllers/LoginForm'
  template = '''
    <div class="login-form"></div>

    <div class="profile">
      <section class="favorites">
        <header>Favorites</header>
        <p class="none">You haven't marked any favorites.</p>
        <ul></ul>
      </section>

      <section class="recents">
        <header>Recents</header>
        <p class="none">You haven't made any classifications recently.</p>
        <ul></ul>
      </section>
    </div>
  '''

  class Profile extends Widget
    className: 'zooniverse-profile'
    template: template

    @element '.username', 'usernameContainer'
    @element '.login-form', 'loginFormContainer'
    @element '.favorites ul', 'favoritesList'
    @element '.recents ul', 'recentsList'
    @element '.groups ul', 'groupsList'

    constructor: ->
      super

      # @loginForm = new LoginForm el: @loginFormContainer

      User.on 'sign-in', @userChanged

      User.on 'add-favorite', @updateFavorites
      User.on 'remove-favorite', @updateFavorites

      User.on 'add-recent', @updateRecents
      User.on 'remove-recent', @updateRecents

      delay @userChanged

    userChanged: =>
      console.log 'Profile noticed user changed', User.current
      @el.toggleClass 'signed-in', User.current?

      if User.current?
        @usernameContainer.html User.current.name
        Favorite.refresh()
        Recent.refresh()

    updateFavorites: =>
      # TODO: Debounce
      console.log 'Profile updating favorites', User.current?.favorites
      # TODO: Pagination
      @favoritesList.empty()
      favorites = User.current.favorites
      @el.toggleClass 'has-favorites', favorites.length > 0
      @favoritesList.prepend @renderFavorite favorite for favorite in favorites

    renderFavorite: (favorite) =>
      $("<li><a href='#{favorite.talkHREF()}'>#{favorite.createdAt}</a></li>")

    updateRecents: =>
      # TODO: Debounce
      console.log 'Profile updating recents', User.current?.recents
      @recentsList.empty()
      recents = User.current.recents
      @el.toggleClass 'has-recents', recents.length > 0
      @recentsList.prepend @renderRecent recent for recent in recents

    renderRecent: (recent) =>
      $("<li><a href='#{recent.talkHREF()}'>#{recent.createdAt}</a></li>")

    @delegate 'click! .sign-out', ->
      User.deauthenticate()

    @delegate 'click! .favorites .delete', (e) ->
      # TODO: This is kinda hacky. This should be a list of controllers,
      # and destroying a model should remove its controller/view automatically.
      target = $(e.target)
      favoriteID = target.data 'favorite'
      favorite = (f for f in User.current.favorites when f.id is favoriteID)[0]

      favorite.destroy true
      target.parent('li').remove()

  module.exports = Profile
