Janitor = require '../.'
FailedAssertionMessage = require '../src/failed_assertion_message'

module.exports = class FailedAssertionMessageTest extends Janitor.TestCase
  'test equal': ->
    failedAssertion =
      type: 'equal'
      options:
        val1: 'a'
        val2: 'b'
    
    message = new FailedAssertionMessage failedAssertion
    @assertEqual 'a does not equal b', message.toString()
