###!
  * Main Function
###

$ = require "jquery"
indexInit = require "./indexInit"
partInit = require "./partInit"

$ ->
  ###
    DECLARATION
  ###
  window.milkcocoa = new window.MilkCocoa "iceia90idbv.mlkcca.com"
  window.sessionDataStore = milkcocoa.dataStore "session"

  if window._DEBUG
    if Object.freeze?
      window.DEBUG = Object.freeze window._DEBUG
    else
      window.DEBUG = state: true
  else
    if Object.freeze?
      window.DEBUG = Object.freeze state: false
    else
      window.DEBUG = state: false

  ###
    INIT
  ###
  if window.location.search.length > 0
    partInit()
  else
    indexInit()
