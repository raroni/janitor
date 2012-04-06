Runner = require 'runner'
BrowserPresenter = require 'browser_presenter'

module.exports = class extends Runner
  presenterClass: BrowserPresenter
  tests: ->
    (window[key] for key in Object.keys(window) when key.substr(-4) == 'Test')
