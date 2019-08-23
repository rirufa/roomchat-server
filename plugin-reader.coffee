fs = require('fs')
loadPlugin = exports.loadPlugin = (dir, fn) ->
  files = fs.readdirSync(dir)
  files.filter((v) ->
    fs.statSync([dir, v].join('/')).isFile()
  ).map (v) ->(
    r = require([dir, v].join('/'))
    fn(r)
  )
