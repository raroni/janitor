FailedAssertMessageResolver = require './failed_assert_message_resolver'

module.exports = class
  constructor: (@tests, @options) ->
    @completed = 0
    @succeeded_asserts = 0
    @failed_asserts = 0
    @asserts = 0
    
    for Test in @tests
      Test.bind 'runCompleted', (test_run) => @handleCompletedRun(test_run)
      Test.bind 'completed', => @checkComplete()

  handleCompletedRun: (run) ->
    @asserts += run.failed_asserts.length + run.succeeded_asserts_count
    @failed_asserts += run.failed_asserts.length
    @succeeded_asserts += run.succeeded_asserts_count
    
    @outputFailedAssert failed_assert for failed_assert in run.failed_asserts
      
  checkComplete: ->
    @completed += 1
    @complete() if @completed == @tests.length
  
  failedAssertDescription: (failed_assert) ->
    "#{failed_assert.run.constructor.name}[#{failed_assert.run.method_name}]: #{@failedAssertMessage(failed_assert)}"
    
  failedAssertMessage: (failed_assert) ->
    new FailedAssertMessageResolver(failed_assert).message()
    
  summaryMessage: ->
    "COMPLETE: #{@asserts} asserts, #{@failed_asserts} failed, #{@succeeded_asserts} succeeded"
