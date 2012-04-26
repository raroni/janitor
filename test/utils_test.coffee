Janitor = require '../.'
Utils = require '../src/utils'

module.exports = class UtilsTest extends Janitor.TestCase
  'test extend': ->
    obj1 =
      name: 'Ras'
      age: 25
    
    obj2 =
      inquisitive: true
    
    Utils.extend obj1, obj2
    
    @assert obj1.inquisitive
