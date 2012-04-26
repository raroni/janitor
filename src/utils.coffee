module.exports =
  extend: (obj1, obj2) ->
    obj1[key] = value for key, value of obj2
  
  firstToUpper: (text) ->
    text.replace(/.{1}/, (v) -> v.toUpperCase())
