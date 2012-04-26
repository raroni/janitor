Janitor = require '../.'
NodeRunner = require '../src/node_runner'

module.exports = class NodeRunnerTest extends Janitor.TestCase
  'test number of files found': ->
    runner = new NodeRunner { dir: __dirname + '/fixtures' }
    @assertEqual 2, runner.files().length
