module.exports = class FailedAssertionMessage
  constructor: (failedAssert) ->
    @type = failedAssert.type
    @result = failedAssert.result
    @refutation = failedAssert.refutation
  
  assertEqual: ->
    "#{@result.actual} does not equal #{@result.expected}"
  
  assertInDelta: ->
    "#{@result.actual} is not within #{@result.expected}±#{@result.delta}"
  
  refuteEqual: ->
    "#{@result.actual} equals #{@result.expected}"
  
  assertTruthy: ->
    "#{@result.value} is not true"
  
  toString: ->
    if @[@methodName()]
      @[@methodName()]()
    else
      "Unknown assert fail: #{@type}"
  
  methodName: ->
    prefix = if @refutation then 'refute' else 'assert'
    prefix + @type.replace(/.{1}/, (v) -> v.toUpperCase())
