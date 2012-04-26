Janitor = require '../.'
Assertions = require '../src/assertions'
Utils = require '../src/utils'

module.exports = class TestCaseTest extends Janitor.TestCase
  'test simplest case': ->
    class SomethingTest extends Janitor.TestCase
      'test me': ->
        @assertEqual 1, 1
    
    testCase = new SomethingTest 'test me'
    testCase.run()
    
    @assertEqual 1, testCase.succeededAssertsCount
  
  'test case with several assertions': ->
    class SomethingTest extends Janitor.TestCase
      'test me': ->
        @assertEqual 1, 1
        @assertEqual 2, 2
        @assertEqual 1, 2
        @assertEqual 1, 3
        @assertEqual 1, 4
    
    testCase = new SomethingTest 'test me'
    testCase.run()
    
    @assertEqual 2, testCase.succeededAssertsCount
    @assertEqual 3, testCase.failedAsserts.length
  
  'test passing assertEqual': ->
    class SomethingTest extends Janitor.TestCase
      'test me': ->
        @assertEqual 1, 1
    
    testCase = new SomethingTest 'test me'
    testCase.run()
    
    @assertEqual 1, testCase.succeededAssertsCount
    @assertEqual 0, testCase.failedAsserts.length
  
  'test failing assertEqual': ->
    class SomethingTest extends Janitor.TestCase
      'test me': ->
        @assertEqual 1, 2
    
    testCase = new SomethingTest 'test me'
    testCase.run()
    
    @assertEqual 0, testCase.succeededAssertsCount
    @assertEqual 1, testCase.failedAsserts.length
    
    failedAssertion = testCase.failedAsserts[0]
    @assertEqual 'equal', failedAssertion.type
    @refute failedAssertion.refutation
    @assertEqual 1, failedAssertion.result.expected
    @assertEqual 2, failedAssertion.result.actual
