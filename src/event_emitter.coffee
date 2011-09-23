module.exports =
  bind: (event, callback) ->
    @_callbacks ||= {}
    @_callbacks[event] ||= []
    @_callbacks[event].push callback
    
  trigger: (event, message) ->
    return unless @_callbacks && list = @_callbacks[event]
    callback(message) for callback in list
