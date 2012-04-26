stitch  = require 'stitch'
fs = require 'fs'

task 'build', 'Build dist file', ->
  jsPackage = stitch.createPackage paths: [__dirname + '/src']
  jsPackage.compile (err, source) ->
    source = """
      window.Janitor = {};
      window.Janitor.Stitch = {};
      (function() {
        #{source}
      }).call(window.Janitor.Stitch);
      window.Janitor.TestCase = Janitor.Stitch.require('test_case'),
      window.Janitor.BrowserRunner = Janitor.Stitch.require('browser_runner')
    """
    fs.writeFileSync __dirname + '/dist/janitor.js', source

task 'test', 'Run test suite', ->
  Janitor = require './src/main'
  runner = new Janitor.NodeRunner { dir: __dirname + '/test/cases' }
  runner.run()
