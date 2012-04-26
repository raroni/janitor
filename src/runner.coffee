module.exports = class
  constructor: (@options) ->
  run: ->
    new @presenterClass @activeTests(), @options
    Test.runAll() for Test in @activeTests()
  
  activeTests: ->
    tests = @tests()
    
    soloTest = null
    tests.forEach (test) ->
      soloTest = test if test.solo
    
    if soloTest then [soloTest] else tests
