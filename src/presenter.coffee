FailedAssertMessageResolver = require './failed_assertion_message'

module.exports = class
  constructor: (@tests, @options) ->
    @completed = 0
    @succeeded_asserts = 0
    @failedAsserts = 0
    @asserts = 0
    
    for Test in @tests
      Test.bind 'runCompleted', (test_run) => @handleCompletedRun(test_run)
      Test.bind 'completed', => @checkComplete()

  handleCompletedRun: (run) ->
    @asserts += run.failedAsserts.length + run.succeededAssertsCount
    @failedAsserts += run.failedAsserts.length
    @succeeded_asserts += run.succeededAssertsCount
    
    @outputFailedAssert failedAssert for failedAssert in run.failedAsserts
      
  checkComplete: ->
    @completed += 1
    @complete() if @completed == @tests.length
  
  failedAssertDescription: (failedAssert) ->
    "#{failedAssert.run.constructor.name}[#{failedAssert.run.methodName}]: #{@failedAssertMessage(failedAssert)}"
    
  failedAssertMessage: (failedAssert) ->
    new FailedAssertMessageResolver(failedAssert).message()
    
  summaryMessage: ->
    "COMPLETE: #{@asserts} asserts, #{@failedAsserts} failed, #{@succeeded_asserts} succeeded"
