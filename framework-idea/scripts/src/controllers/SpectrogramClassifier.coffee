define (require, exports, module) ->
  Workflow = require 'zooniverse/controllers/Workflow'
  Spectrogram = require 'models/Spectrogram'

  class SpectrogramClassifier extends Workflow

  module.exports = SpectrogramClassifier
