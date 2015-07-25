$ = require "jquery"
musicData = {}
musicData.jazz = require "./model/jazz"
musicData.rock = require "./model/rock"

indexInit = ->
  ###
    DECLARATION
  ###
  is_started = false
  audio = new Audio()
  audio.src = "audio/jazz/guitar-right.mp3"
  selected_bpm = null

  # calc popup position
  if window.screenLeft?
    dualScreenLeft = window.screenLeft
    dualScreenTop = window.screenTop
  else
    dualScreenLeft = screen.left
    dualScreenTop = screen.top

  if window.innerWidth?
    windowWidth = window.innerWidth
    windowHeight = window.innerHeight
  else if document.documentElement?.clientWidth?
    windowWidth = document.documentElement.clientWidth
    windowWidth = document.documentElement.clientHeight
  else
    windowWidth = screen.width
    windowWidth = screen.height

  popupWidth = windowWidth / 3
  popupHeight = popupWidth * 0.75
  MARGIN = 40

  TOP_POSITION =
    top: dualScreenTop + MARGIN
    middle: ( dualScreenTop + windowHeight ) / 2 -
            popupHeight / 2
    bottom: dualScreenTop + windowHeight - popupHeight - MARGIN

  LEFT_POSITION =
    left: dualScreenLeft + MARGIN
    center: dualScreenLeft +
            ( ( windowWidth / 2 ) - ( popupWidth / 2 ) )
    right: dualScreenLeft + windowWidth - MARGIN

  ###
    EVENT LISTENER
  ###
  sessionDataStore.on "send", ( e )->
    if e.value.event == "PART_STARTED"
      if !is_started
        # 時間計測のため
        is_started = true
        audio.volume = 0
        audio.play()
      sessionDataStore.send
        event: "SYN"
        startTime: Date.now() - audio.currentTime * 1000
    else if e.value.event == "CHANGE_RHYTHM"
      selected_bpm = e.value.bpm
      sessionDataStore.send
        event: "DISPATCH_RHYTHM"
        bpm: selected_bpm

  # DOM
  record_time = []
  $( ".start" ).on "click", ( e )->
    e.preventDefault()

    for i in [ 0...musicData[ music ].part.length ]
      _setPart musicData[ music ].part[ i ]

    ###
    record_time.push global.performance.now()
    if record_time.length == 4
      bpm = Math.round( ( 1 / ( ( record_time[ record_time.length - 1 ] -
            record_time[ 0 ] ) / 4000 ) ) * 60 )

      for i in [ 0...musicData[ music ].part.length ]
        _setPart musicData[ music ].part[ i ], bpm
    ###

  $( ".ttl" ).on "click", ->
    window.location.hash = "rock"
    window.location.reload()

  ###
    PRIVATE
  ###

  _setPart = ( _part )->
    setTimeout ->
      if selected_bpm?
        _bpm = selected_bpm
      else
        _bpm = musicData[ music ].bpm

      $( ".#{ _part.part }" ).hide() #wrapperから消す
      window.open "./?part=#{ _part.part }&bpm=#{ _bpm }&music=#{ music }",
                  " #{ _part.part }",
                  "width=#{ popupWidth * _part.size }, " +
                  "height=#{ popupHeight * _part.size }, " +
                  "top=#{ TOP_POSITION[ _part.top ]}," +
                  "left=#{ LEFT_POSITION[ _part.left ] }"
    , _part.start

  ###
    INIT
  ###
  $( "h1.ttl, .wrapper" ).show()

  music = "jazz"
  if window.location.hash == "#rock"
    music = "rock"

module.exports = indexInit
