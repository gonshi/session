$ = require "jquery"
Ticker = require "./util/ticker"
musicData = {}
musicData.jazz = require "./model/jazz"
musicData.rock = require "./model/rock"

partInit = ->
  ###
    DECLARATION
  ###
  query = window.location.search.substring 1
  rowParam = query.split "&"
  getParam = {}
  for i in [ 0...rowParam.length ]
    _param = rowParam[ i ].split "="
    getParam[ _param[ 0 ] ] = _param[ 1 ]

  part = getParam.part
  ticker = Ticker()

  audioRight = new Audio()
  audioRight.loop = true

  audioLeft = new Audio()
  audioLeft.loop = true
  howling = new Audio
  howling.src = "audio/howling.mp3"

  is_play = false

  PART_NAME =
    drum: "ドラム"
    bass: "ベース"
    guitar: "ギター"
    vocal: "ボーカル"
    conga: "コンガ"
    piano: "ピアノ"

  ###
    EVENT LISTENER
  ###
  sessionDataStore.on "push", ( e )->
    if e.value.event == "SYN" && !is_play
      is_play = true
      _currentTime = parseFloat( ( ( Date.now() -
                     e.value.startTime ) / 1000 ).toFixed( 3 ) )
      audioRight.currentTime = _currentTime
      audioLeft.currentTime = _currentTime
      audioRight.play()
      audioLeft.play()

    else if e.value.event == "WINDOW_POS" && part == "guitar2"
      if Math.abs( window.screenLeft - e.value.left ) < 400
        howling.volume = 0.2
        howling.play()
      else
        howling.pause()

    else if e.value.event == "DISPATCH_RHYTHM"
      audioLeft.playbackRate = e.value.bpm / originalBpm
      audioRight.playbackRate = e.value.bpm / originalBpm

  if part == "drum"
    click_count = 0
    record_time = []
    $( ".wrapper-part" ).on "click", ->
      record_time.push window.performance.now()
      click_count += 1
      if click_count % 4 == 0
        bpm = ( 1 / ( ( record_time[ record_time.length - 1 ] -
              record_time[ record_time.length - 4 ] ) / 4000 ) ) * 60
        sessionDataStore.push
          event: "CHANGE_RHYTHM"
          bpm: bpm


  ticker.listen ->
    _setVolume()

  ###
    PRIVATE
  ###

  MAX_SQUARE = screen.width * screen.height
  _setVolume = ->
    volume = ( window.innerWidth * window.innerHeight ) /
             MAX_SQUARE
    rightPan = ( ( window.screenLeft + window.innerWidth ) / 2 ) /
               screen.width
    rightPan *= rightPan

    rightVolume = volume * ( rightPan * 2 )
    rightVolume = 1 if rightVolume > 1
    leftVolume = volume * ( ( 0.5 - rightPan ) * 2 )
    leftVolume = 1 if leftVolume > 1
    audioRight.volume = rightVolume
    audioLeft.volume = leftVolume

    if part == "guitar1" && window.screenLeft != 0
      sessionDataStore.push
        event: "WINDOW_POS"
        left: window.screenLeft

  ###
    INIT
  ###

  originalBpm = musicData[ getParam.music ].bpm

  $( "title" ).text PART_NAME[ part ]

  ticker.setFps 15
  $( ".wrapper-part" ).show()
  partName = part.replace /[0-9]/, ""
  $( ".part" ).css
    "background-image": "url('img/part/#{ partName }.png')"
  .show()

  audioRight.src = "audio/#{ getParam.music }/#{ part }-right.mp3"
  audioLeft.src = "audio/#{ getParam.music }/#{ part }-left.mp3"
  audioRight.playbackRate = getParam.bpm / originalBpm
  audioLeft.playbackRate = getParam.bpm / originalBpm

  sessionDataStore.push
    event: "PART_STARTED"
    part: part

module.exports = partInit
