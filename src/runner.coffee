module.exports = class
  constructor: (@options) ->
  run: ->
    new @presenterClass @tests(), @options
    Test.runAll() for Test in @tests()
