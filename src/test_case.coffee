_ = require 'underscore'
Asserts = require './asserts'
EventEmitter = require './event_emitter'

module.exports = class
  @runs = []
  
  @runAll: ->
    @completed = 0
    if @testMethodNames().length > 0
      @run method_name for method_name in @testMethodNames()
    else
      @complete()
  
  @run: (method_name) ->
    run = new @ method_name
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
    (method_name for method_name in Object.keys(@prototype) when method_name.substr(0,5) == 'test ' or @methodNameIsAsync(method_name))
    
  @methodNameIsAsync: (method_name) ->
    method_name.substr(0,11) == 'async test '
  
  constructor: (@method_name) ->
    @succeeded_asserts_count = 0
    @failed_asserts = []
  
  run: ->
    @setup() if @setup
    @[@method_name]()
    @teardown() if @teardown
    @complete() unless @async()
  
  async: ->
    @constructor.methodNameIsAsync @method_name
  
  complete: ->
    @completed = true
    @trigger 'completed'
  
  store_assert: (type, succeeded, options = {})->
    if succeeded
      @succeeded_asserts_count += 1
    else
      @failed_asserts.push({type, succeeded, options, run: @})
      
  succeeded: ->
    @completed && @failed_asserts == 0

_.extend module.exports.prototype, Asserts
_.extend module.exports.prototype, EventEmitter
_.extend module.exports, EventEmitter

