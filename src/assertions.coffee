module.exports =
  equal: (expected, actual) ->
    success = expected == actual
    { success, expected, actual }
  
  truthy: (value) ->
    success = !!value
    { success, value }
  
  throws: (callback, check) ->
    caught = false
    error = null
    try
      callback()
    catch thrownError
      caught = true
      error = thrownError
    
    success = caught && (!check || check(error))
    
    { success, callback, error }
  
  contains: (container, value) ->
    success = container.indexOf(value) != -1
    { success, container, value }
  
  all: (enumerable, callback) ->
    success = true
    enumerable.forEach (item) ->
      success = callback(item) if success
    
    { success, callback }
  
  inDelta: (expected, actual, delta) ->
    success = expected-delta < actual && expected+delta > actual
    { success, expected, actual, delta }
