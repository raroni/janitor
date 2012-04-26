Assertsions = require './assertions'
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
  
  storeAssert: (type, succeeded, options = {})->
    if succeeded
      @succeededAssertsCount += 1
    else
      @failedAsserts.push({type, succeeded, options, run: @})
  
  succeeded: ->
    @completed && @failedAsserts == 0

Utils.extend module.exports.prototype, Assertsions
Utils.extend module.exports.prototype, EventEmitter
Utils.extend module.exports, EventEmitter
