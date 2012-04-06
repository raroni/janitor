Presenter = require './presenter'

module.exports = class extends Presenter
  outputFailedAssert: (failedAssert) ->
    console.log @failedAssertDescription(failedAssert)
  complete: ->
    console.log @summaryMessage()
