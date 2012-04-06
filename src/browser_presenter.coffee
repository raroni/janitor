Presenter = require './presenter'

module.exports = class extends Presenter
  outputFailedAssert: (failed_assert) ->
    text = @failedAssertDescription failed_assert
    el = document.createElement 'div'
    el.innerHTML = text
    el.style.color = 'red'
    @options.el.appendChild el
  complete: ->
    el = document.createElement 'div'
    el.innerHTML = @summaryMessage()
    @options.el.appendChild el
