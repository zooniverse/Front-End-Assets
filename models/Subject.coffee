define (require, exports, module) ->
  Base = require 'Base'

  class Subject extends Base
    @deserialize: (raw) =>
      console.log 'SUBJECT', raw
      new @
        id: raw.id
        zooniverseID: raw.zooniverse_id
        location: raw.location
        coords: raw.coords
        metadata: raw.metadata

    id: ''
    zooniverseID: ''
    location: ''
    coords: ''
    metadata: ''

  module.exports = Subject
