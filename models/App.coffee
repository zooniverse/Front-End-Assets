define (require, exports, module) ->
  Spine = require 'Spine'

  User = require 'zooniverse/models/User'
  Authentication = require 'zooniverse/controllers/Authentication'
  AppController = require 'zooniverse/controllers/App'

  class App extends Spine.Model
    # Has many projects
    @configure 'App', 'host', 'languages', 'el', 'talkHost', 'facebookId', 'cartoUser', 'cartoApiKey', 'cartoTable', 'controller', 'projects'
    host: 'http://some.ouroboros.server'
    authentication: "https://some.s3.bucket/path/to/auth.html"
    languages: null
    projects: null

    unless location.port is 80
      @::host = "//#{location.hostname}:3000"
      @::authentication = "//#{location.host}/login-frame/index.html"

    constructor: ->
      super
      Authentication.setSrc @authentication
      User.bind 'sign-in', (user) => user.app = @
      @controller = new AppController app: @, el: @el, languages: @languages
      project.app = @ for project in @projects if @projects?

    save: =>
      super
      project.save() for project in @projects

  module.exports = App
