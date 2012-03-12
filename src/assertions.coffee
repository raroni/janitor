module.exports =
  assertEqual: (val1, val2) ->
    @store_assert 'equal', val1 == val2, {val1, val2}
  
  assert: (exp) ->
    @store_assert 'true', exp, {exp}
  
  assertThrows: (callback, check) ->
    caught = false
    error = null
    try
      callback()
    catch thrown_error
      caught = true
      error = thrown_error
    
    success = caught && (!check || check(error))
    
    @store_assert 'throw', success, {callback, error}
  
  refuteThrows: (callback) ->
    caught = false
    error = null
    try
      callback()
    catch thrown_error
      caught = true
      error = thrown_error
    
    success = !caught
    
    @store_assert 'refute_throw', success, {callback, error}
  
  assertContains: (container, value) ->
    result = container.indexOf(value) != -1
    @store_assert 'contains', result, {container, value}
