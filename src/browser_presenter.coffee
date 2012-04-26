Presenter = require './presenter'

module.exports = class extends Presenter
  outputFailedAssert: (failedAssert) ->
    text = @failedAssertDescription failedAssert
    el = document.createElement 'div'
    el.innerHTML = text
    el.style.color = 'red'
    @options.el.appendChild el
  
  complete: ->
    el = document.createElement 'div'
    el.innerHTML = @summaryMessage()
    @options.el.appendChild el
