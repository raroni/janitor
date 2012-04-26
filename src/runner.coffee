module.exports = class
  constructor: (@options) ->
  run: ->
    new @presenterClass @activeTests(), @options
    Test.runAll() for Test in @activeTests()
  
  activeTests: ->
    tests = @tests()
    soloTest = tests.filter((test) -> test.solo)[0]
    if soloTest then [soloTest] else tests
