ConsolePresenter = require './console_presenter'
Runner = require './runner'
Glob = require 'glob'

module.exports = class extends Runner
  presenter_class: ConsolePresenter
  
  tests: ->
    (require(file) for file in @files())
  
  files: ->
    Glob.globSync "#{@options.dir}/**_test.coffee"
