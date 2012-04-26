module.exports = class
  constructor: (@options) ->
  run: ->
    new @presenterClass @activeTests(), @options
    Test.runAll() for Test in @tests()
  
  activeTests: ->
    tests = @tests()
    soloTest = null
    tests.forEach (test) ->
      soloTest = test if test.solo
    
    soloTest || tests
