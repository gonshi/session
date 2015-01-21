$ = require "jquery"
EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instance = null

class ResizeHandler extends EventDispatcher

  constructor: ->
    super()

  exec: ->
    throttle = new Throttle 200
    $( window ).on "resize", =>
      throttle.exec =>
        @dispatch "RESIZED", this

getInstance = ->
  if !instance
    instance = new ResizeHandler()
  return instance

module.exports = getInstance
