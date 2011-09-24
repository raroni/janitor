Runner = require 'runner'
WebPresenter = require 'web_presenter'

module.exports = class extends Runner
  presenter_class: WebPresenter
  tests: ->
    (window[key] for key in Object.keys(window) when key.substr(-4) == 'Test')
