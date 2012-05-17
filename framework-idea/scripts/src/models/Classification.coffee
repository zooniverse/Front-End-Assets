define (require, exports, module) ->
  ZooniverseClassification = require 'zooniverse/models/Classification'

  class Classification extends ZooniverseClassification
    @configure 'Classification', 'cool'

  module.exports = Classification
