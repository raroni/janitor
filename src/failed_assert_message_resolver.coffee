class TestUnit.FailedAssertMessageResolver
  constructor: (failed_assert) ->
    @type = failed_assert.type
    @options = failed_assert.options
    
  message: ->
    if @[@type]
      @[@type]()
    else
      "Unknown assert fail: #{@type}"
    
  equal: ->
    "#{@options.val1} does not equal #{@options.val2}"
  
  true: ->
    "#{@options.exp} is not true"
