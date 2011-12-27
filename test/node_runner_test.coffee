Janitor = require '../.'
NodeRunner = require '../src/node_runner'

module.exports = class extends Janitor.TestCase
  'test number of files found': ->
    runner = new NodeRunner { dir: __dirname + '/fixtures' }
    @assert_equal 2, runner.files().length
