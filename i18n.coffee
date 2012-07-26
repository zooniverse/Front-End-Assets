define (require, exports, module) ->
  $ = require 'jQuery'
  {getObject} = require 'zooniverse/util'

  attribute = 'data-i18n'
  translationsRoot = 'translations'

  # Basically, 'nav/home': $('[data-i18n="nav"] [data-i18n="home"]')
  elementsMap = {}

  # Store translations so we don't need to download them again.
  translationCache = {}

  # Set up the elements map.
  for target in $("[#{attribute}]")
    target = $(target)
    continue unless target.find("[#{attribute}]").length is 0

    tree = target.parents("[#{attribute}]").andSelf()
    path = ($(el).attr attribute for el in tree).join '/'

    elementsMap[path] = target

  # Apply a cached translation.
  applyFromCache = (lang) ->
    $('html').attr 'lang', lang
    for path, target of elementsMap
      content = getObject path, translationCache[lang]
      target.html content if content?

  # Apply a translation, request if not cached.
  translate = (e..., lang) ->
    console.log 'Translating into', lang
    if lang of translationCache
      applyFromCache lang
    else
      $.get "#{translationsRoot}/#{lang}.json", (response) ->
        translationCache[lang] = response
        applyFromCache lang

  $(document).on 'request-translation', translate

  module.exports = {translate, elementsMap, translationCache}
