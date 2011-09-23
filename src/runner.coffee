module.exports = class
  constructor: (@options) ->
  run: ->
    new @presenter_class @tests(), @options
    Test.runAll() for Test in @tests()
