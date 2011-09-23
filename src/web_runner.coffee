web_presenter = require 'web_presenter'

module.exports =
  presenter_class: web_presenter
  tests: ->
    (window[key] for key in Object.keys(window) when key.substr(-4) == 'Test')
