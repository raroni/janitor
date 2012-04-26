Janitor = require '../.'
NodeRunner = require '../src/node_runner'

module.exports = class NodeRunnerTest extends Janitor.TestCase
  'test number of files found': ->
    runner = new NodeRunner { dir: __dirname + '/fixtures/simple' }
    @assertEqual 2, runner.files().length
  
  'test number of tests found': ->
    runner = new NodeRunner { dir: __dirname + '/fixtures/simple' }
    @assertEqual 2, runner.tests().length
    @assertAll runner.tests(), (t) -> Object.getPrototypeOf(t.prototype) == Janitor.TestCase.prototype
  
  'test solo': ->
    runner = new NodeRunner { dir: __dirname + '/fixtures/solo' }
    @assertEqual 1, runner.tests().length
