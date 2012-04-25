module.exports =
  assertEqual: (expected, actual) ->
    success = expected == actual
    @storeAssert 'equal', success, {expected, actual}
  
  assert: (exp) ->
    @storeAssert 'true', exp, {exp}
  
  assertThrows: (callback, check) ->
    caught = false
    error = null
    try
      callback()
    catch thrownError
      caught = true
      error = thrownError
    
    success = caught && (!check || check(error))
    
    @storeAssert 'throw', success, {callback, error}
  
  refuteThrows: (callback) ->
    caught = false
    error = null
    try
      callback()
    catch thrownError
      caught = true
      error = thrownError
    
    success = !caught
    
    @storeAssert 'refuteThrow', success, {callback, error}
  
  assertContains: (container, value) ->
    result = container.indexOf(value) != -1
    @storeAssert 'contains', result, {container, value}
  
  assertAll: (enumerable, callback) ->
    success = true
    enumerable.forEach (item) ->
      success = callback(item) if success
    
    @storeAssert 'all', success, { callback }
  
  assertInDelta: (expected, actual, delta) ->
    success = expected-delta < actual && expected+delta > actual
    @storeAssert 'inDelta', success, { expected, actual, delta }
