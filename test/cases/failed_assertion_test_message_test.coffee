Janitor = require '../../.'
FailedAssertionMessage = require '../../src/failed_assertion_message'

module.exports = class FailedAssertionMessageTest extends Janitor.TestCase
  'test equal': ->
    failedAssertion =
      type: 'equal'
      result:
        expected: 'a'
        actual: 'b'
    
    message = new FailedAssertionMessage failedAssertion
    @assertEqual 'b does not equal a', message.toString()
  
  'test truthy': ->
    failedAssertion =
      type: 'truthy'
      result:
        value: false
    
    message = new FailedAssertionMessage failedAssertion
    @assertEqual 'false is not true', message.toString()
  
  'test in delta': ->
    failedAssertion =
      type: 'inDelta'
      result:
        expected: 25
        actual: 25.2
        delta: 0.1
    
    message = new FailedAssertionMessage failedAssertion
    @assertEqual '25.2 is not within 25±0.1', message.toString()
  
  'test refute equal': ->
    failedAssertion =
      type: 'equal'
      refutation: true
      result:
        expected: 2
        actual: 2
    
    message = new FailedAssertionMessage failedAssertion
    @assertEqual '2 equals 2', message.toString()
