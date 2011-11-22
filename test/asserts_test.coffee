Janitor = require '../.'
Asserts = require '../src/asserts'
Utils = require '../src/utils'

module.exports = class extends Janitor.TestCase
  setup: ->
    class Assertable
      store_assert: (type, succeeded, options) ->
        @last_assert = { type, succeeded, options}
      
    Utils.extend Assertable.prototype, Asserts
    @assertable = new Assertable
  
  'test passing equal assertion': ->
    @assertable.assert_equal 1,1
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assert_equal 'equal', assert.type
    @assert_equal 1, assert.options.val1
    @assert_equal 1, assert.options.val2
    
  'test failing equal assertion': ->
    @assertable.assert_equal 2,3
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assert_equal 'equal', assert.type
    @assert_equal 2, assert.options.val1
    @assert_equal 3, assert.options.val2
    
  'test passing truth assertion': ->
    @assertable.assert true
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assert_equal 'true', assert.type
    @assert_equal true, assert.options.exp

  'test failing truth assertion': ->
    @assertable.assert false
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assert_equal 'true', assert.type
    @assert_equal false, assert.options.exp
