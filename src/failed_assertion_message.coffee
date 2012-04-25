module.exports = class FailedAssertionMessage
  constructor: (failedAssert) ->
    @type = failedAssert.type
    @options = failedAssert.options
    
  equal: ->
    "#{@options.val1} does not equal #{@options.val2}"
  
  true: ->
    "#{@options.exp} is not true"
  
  inDelta: ->
    "#{@options.actual} is not within #{@options.expected}±#{@options.delta}"
  
  toString: ->
    if @[@type]
      @[@type]()
    else
      "Unknown assert fail: #{@type}"