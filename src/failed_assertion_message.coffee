module.exports = class
  constructor: (failedAssert) ->
    @type = failedAssert.type
    @options = failedAssert.options
    
  message: ->
    if @[@type]
      @[@type]()
    else
      "Unknown assert fail: #{@type}"
    
  equal: ->
    "#{@options.val1} does not equal #{@options.val2}"
  
  true: ->
    "#{@options.exp} is not true"
