stitch  = require 'stitch'
fs = require 'fs'

# TODO: do not require all of underscore

task 'build', 'Build dist file', ->
  package = stitch.createPackage paths: [__dirname + '/src', __dirname + '/node_modules/underscore']
  package.compile (err, source) ->
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
