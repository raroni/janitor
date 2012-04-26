module.exports = class FailedAssertionMessage
  constructor: (failedAssert) ->
    @type = failedAssert.type
    @options = failedAssert.options
    
  equal: ->
    "#{@options.actual} does not equal #{@options.expected}"
  
  true: ->
    "#{@options.exp} is not true"
  
  inDelta: ->
    "#{@options.actual} is not within #{@options.expected}±#{@options.delta}"
  
  refuteEqual: ->
    "#{@options.actual} equals #{@options.expected}"
  
  toString: ->
    if @[@type]
      @[@type]()
    else
      "Unknown assert fail: #{@type}"
