Assertions = require './assertions'
EventEmitter = require './event_emitter'
Utils = require './utils'

module.exports = class
  @runs = []
  
  @runAll: ->
    @completed = 0
    if @testMethodNames().length > 0
      @run methodName for methodName in @testMethodNames()
    else
      @complete()
  
  @run: (methodName) ->
    run = new @ methodName
    run.bind 'completed', => @runCompleted(run)
    run.run()
    @runs.push run
  
  @runCompleted: (run) ->
    @trigger 'runCompleted', run
    @completed += 1
    @complete() if @completed == @testMethodNames().length
    
  @complete: ->
    @trigger 'completed'

  @testMethodNames: ->
    (methodName for methodName in Object.keys(@prototype) when methodName.substr(0,5) == 'test ' or @methodNameIsAsync(methodName))
    
  @methodNameIsAsync: (methodName) ->
    methodName.substr(0,11) == 'async test '
  
  constructor: (@methodName) ->
    @succeededAssertsCount = 0
    @failedAsserts = []
  
  run: ->
    @setup() if @setup
    @[@methodName]()
    @teardown() if @teardown
    @complete() unless @isAsync()
  
  isAsync: ->
    @constructor.methodNameIsAsync @methodName
  
  complete: ->
    @completed = true
    @trigger 'completed'
  
  storeAssert: (type, refutation, result)->
    if result.success
      @succeededAssertsCount += 1
    else
      @failedAsserts.push({type, refutation, result, run: @})
  
  succeeded: ->
    @completed && @failedAsserts == 0
  
  runAssertion: (type, options) ->
    result = Assertions[type].apply null, options.args
    
    result.success = !result.succes if options.refutation
    
    @storeAssert type, options.refutation, result
  
  ######### API:
  
  assertEqual: (args...) ->
    @runAssertion 'equal', { args }
  
  refuteEqual: (expected, actual) ->
    @runAssertion 'equal', { args, refutation: true }
  
  assert: (args...) ->
    @runAssertion 'truthy', { args, refutation: true }
  
  assertThrows: (args...) ->
    @runAssertion 'throws', { args }
  
  refuteThrows: (args...) ->
    @runAssertion 'throws', { args, refutation: true }
  
  assertContains: (args...) ->
    @runAssertion 'contains', { args }
  
  assertAll: (args...) ->
    @runAssertion 'all', { args }
  
  assertInDelta: (args...) ->
    @runAssertion 'inDelta', { args }

#Utils.extend module.exports.prototype, Assertions
Utils.extend module.exports.prototype, EventEmitter
Utils.extend module.exports, EventEmitter
