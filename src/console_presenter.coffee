Presenter = require './presenter'

module.exports = class extends Presenter
  outputFailedAssert: (failed_assert) ->
    console.log @failedAssertDescription(failed_assert)
  complete: ->
    console.log @summaryMessage()
