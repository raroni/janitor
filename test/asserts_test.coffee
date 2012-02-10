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
    @assertable.assertEqual 1,1
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'equal', assert.type
    @assertEqual 1, assert.options.val1
    @assertEqual 1, assert.options.val2
    
  'test failing equal assertion': ->
    @assertable.assertEqual 2,3
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assertEqual 'equal', assert.type
    @assertEqual 2, assert.options.val1
    @assertEqual 3, assert.options.val2
    
  'test passing truth assertion': ->
    @assertable.assert true
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'true', assert.type
    @assertEqual true, assert.options.exp

  'test failing truth assertion': ->
    @assertable.assert false
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assertEqual 'true', assert.type
    @assertEqual false, assert.options.exp
  
  'test passing throws assertion': ->
    callback = -> throw 'me!'
    @assertable.assertThrows callback
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'throw', assert.type
    @assertEqual callback, assert.options.callback
  
  'test passing throws assertion with second argument being a function': ->
    callback = -> throw new Error 'wee'
    check = (e) -> e.message == 'wee'
    @assertable.assertThrows callback, check
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'throw', assert.type
    @assertEqual callback, assert.options.callback
  
  'test failing throws assertion': ->
    callback = -> "Forget it! I won't throw anything"
    @assertable.assertThrows callback
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assertEqual 'throw', assert.type
    @assertEqual callback, assert.options.callback
  
  'test throws assertion fails if second argument is a function that returns false': ->
    callback = -> throw new Error 'Secret!'
    check = (e) -> e.message == 'dunno'
    @assertable.assertThrows callback, check
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assertEqual 'throw', assert.type
    @assertEqual callback, assert.options.callback
  
  'test passing contains assertion': ->
    @assertable.assertContains [1,2,3], 1
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'contains', assert.type
    @assert Array.isArray(assert.options.container)
    @assertEqual 3, assert.options.container.length
    @assertEqual i, assert.options.container[i-1] for i in [1..3]
    @assertEqual 1, assert.options.value
