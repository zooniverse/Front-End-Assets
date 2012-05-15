{spawn} = require 'child_process'

run = (command...) ->
  child = spawn command...
  child.stderr.on 'data', (data) -> process.stderr.write data.toString()
  child.stdout.on 'data', (data) -> process.stdout.write data.toString()

task 'dev', 'Development server', ->
  run 'coffee', ['--compile', '--watch', '.']
  run 'python', ['-m', 'SimpleHTTPServer', 8000]
