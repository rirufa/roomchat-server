express = require('express')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)
PORT = process.env.PORT or 8080
http.listen PORT, ->
  console.log 'server listening. Port:' + PORT
  return

pluginLoader = require('./plugin-reader').loadPlugin

#apis
controllers = pluginLoader('./controller/user', (r)->
  if r.__super__.constructor.name == 'ApiBaseController'
    new r(app, r.ENTRYPOINT)
  else if r.__super__.constructor.name == 'SocketIoBaseController'
    new r(io, r.ENTRYPOINT)
)