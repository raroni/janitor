Janitor = require '../../.'
Assertions = require '../../src/assertions'
Utils = require '../../src/utils'

module.exports = class AssertionsTest extends Janitor.TestCase
  'test passing equal': ->
    result = Assertions.equal 1, 1
    @assert result.success
    @assertEqual 1, result.expected
    @assertEqual 1, result.actual
    
  'test failing equal': ->
    result = Assertions.equal 2, 3
    @refute result.success
    @assertEqual 2, result.expected
    @assertEqual 3, result.actual
    
  'test passing truthy': ->
    result = Assertions.truthy true
    @assert result.success
    @assertEqual true, result.value
  
  'test failing truthy': ->
    result = Assertions.truthy false
    @refute result.success
    @assertEqual false, result.value
  
  'test passing throws': ->
    callback = -> throw 'me!'
    result = Assertions.throws callback
    @assert result.success
    @assertEqual callback, result.callback
  
  'test passing throws with second argument being a function': ->
    callback = -> throw new Error 'wee'
    check = (e) -> e.message == 'wee'
    result = Assertions.throws callback, check
    @assert result.success
    @assertEqual callback, result.callback
  
  'test failing throws': ->
    callback = -> "Forget it! I won't throw anything"
    result = Assertions.throws callback
    @refute result.success
    @assertEqual callback, result.callback
  
  'test throws fails if second argument is a function that returns false': ->
    callback = -> throw new Error 'Secret!'
    check = (e) -> e.message == 'dunno'
    result = Assertions.throws callback, check
    @refute result.success
    @assertEqual callback, result.callback
  
  'test passing contains': ->
    result = Assertions.contains [1,2,3], 1
    @assert result.success
    @assert Array.isArray(result.container)
    @assertEqual 3, result.container.length
    @assertEqual i, result.container[i-1] for i in [1..3]
    @assertEqual 1, result.value
  
  'test passing all': ->
    persons = [
      { name: 'Ras', age: 26 },
      { name: 'Jeff', age: 22 }
    ]
    isAdult = (item) -> item.age >= 20
    
    result = Assertions.all persons, isAdult
    @assert result.success
    @assertEqual isAdult, result.callback
  
  'test failing all': ->
    persons = [
      { name: 'Ras', age: 26 },
      { name: 'Jeff', age: 14 }
    ]
    isAdult = (item) -> item.age >= 20
    
    result = Assertions.all persons, isAdult
    @refute result.success
    @assertEqual isAdult, result.callback
  
  'test passing in delta': ->
    result = Assertions.inDelta 25, 25.1, 0.25
    @assert result.success
    @assertEqual 0.25, result.delta
    @assertEqual 25, result.expected
    @assertEqual 25.1, result.actual
  
  'test failing in delta': ->
    result = Assertions.inDelta 25, 25.2, 0.1
    @refute result.success
    @assertEqual 0.1, result.delta
    @assertEqual 25, result.expected
    @assertEqual 25.2, result.actual
  
  'test passing matches': ->
    regEx = /[0-9]/
    result = Assertions.match regEx, '1' 
    @assert result.success
    @assertEqual regEx, result.regEx
    @assertEqual '1', result.actual
  
  'test failing matches': ->
    regEx = /[0-9]/
    result = Assertions.match regEx, 'a' 
    @refute result.success
    @assertEqual regEx, result.regEx
    @assertEqual 'a', result.actual
