Assertions = require './assertions'
EventEmitter = require './event_emitter'
Utils = require './utils'

class TestCase
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
  
  @addAssertionMethods: (type) ->
    @addAssertionMethod type
    @addAssertionMethod type, true
  
  @addAssertionMethod: (type, refutation) ->
    prefix = if refutation then 'refute' else 'assert'
    suffix = if type == 'truthy' then '' else Utils.firstToUpper(type)
    name = prefix + suffix
    @prototype[name] = (args...) -> @runAssertion type, { args, refutation }
  
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
    result.success = !result.success if options.refutation
    @storeAssert type, options.refutation, result

TestCase.addAssertionMethods key for key in Object.keys(Assertions)

Utils.extend TestCase.prototype, EventEmitter
Utils.extend TestCase, EventEmitter

module.exports = TestCase
