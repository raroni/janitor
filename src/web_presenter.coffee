Presenter = require './presenter'

module.exports = class extends Presenter
  outputFailedAssert: (failed_assert) ->
    text = @failedAssertDescription failed_assert
    el = $('<div>').text(text)
    el.css color: 'red'
    $(@el).append el
  complete: ->
    $(@el).append $('<div>').text(@summaryMessage())
