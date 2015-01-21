class EventDispatcher
  constructor: ->
    @listeners = {}

  listen: ( eventName, callback )->
    if @listeners[ eventName ]?
      @listeners[ eventName ].push callback
    else
      @listeners[ eventName ] = [ callback ]

  clear: ( eventName )->
    @listeners[ eventName ] = []

  dispatch: ( eventName, opt_this, arg... )->
    if @listeners[ eventName ]
      for listener in @listeners[ eventName ]
        listener.apply opt_this || @, arg

module.exports = EventDispatcher
