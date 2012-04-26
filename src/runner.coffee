module.exports = class
  constructor: (@options) ->
  run: ->
    tests = @activeTests()
    new @presenterClass tests, @options
    Test.runAll() for Test in tests
  
  activeTests: ->
    tests = @tests()
    soloTest = tests.filter((test) -> test.solo)[0]
    if soloTest then [soloTest] else tests
