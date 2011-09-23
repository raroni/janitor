TestCase = require '../src/test_case'
EventEmitter = require '../src/event_emitter'
_ = require 'underscore'

module.exports = class extends TestCase
  setup: ->
    class User
    _.extend User.prototype, EventEmitter
    @user = new User
  
  'test trigger': ->
    @user.bind 'smiling', =>
      @happy = true
    @user.trigger 'smiling'
    @assert @happy
