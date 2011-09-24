stitch  = require 'stitch'
fs = require 'fs'

# TODO: do not define require publicly (use scope), do not require all of underscore

task 'build', 'Build dist file', ->
  package = stitch.createPackage paths: [__dirname + '/src', __dirname + '/node_modules/underscore']
  package.compile (err, source) ->
    source += "\n"
    source += "window.Janitor = { TestCase: require('test_case'), WebRunner: require('web_runner') };\n"
    fs.writeFileSync __dirname + '/dist/janitor.js', source
