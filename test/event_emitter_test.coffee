Janitor = require '../.'
EventEmitter = require '../src/event_emitter'
Utils = require '../src/utils'

module.exports = class extends Janitor.TestCase
  setup: ->
    class User
    Utils.extend User.prototype, EventEmitter
    @user = new User
  
  'test trigger': ->
    @user.bind 'smiling', =>
      @happy = true
    @user.trigger 'smiling'
    @assert @happy
