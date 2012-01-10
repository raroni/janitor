module.exports =
  assertEqual: (val1, val2) ->
    @store_assert 'equal', val1 == val2, {val1, val2}
  
  assert: (exp) ->
    @store_assert 'true', exp, {exp}
  
  assertThrows: (callback) ->
    caught = false
    error = null
    try
      callback()
    catch thrown_error
      caught = true
      error = thrown_error
    @store_assert 'throw', caught, {callback, error}
