express = require('express')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)
PORT = process.env.PORT or 8080
http.listen PORT, ->
  console.log 'server listening. Port:' + PORT
  return

# config for body-parser
bodyParser = require( 'body-parser' )
app.use bodyParser.urlencoded({ extended: true})
app.use bodyParser.json()

# DB connection
mongoose = require('mongoose')
constants = Object.freeze({
  DB_URL: "mongodb://127.0.0.1:27017/",
  DB_NAME: "room-chat-server"
})
mongoose.connect(constants.DB_URL + constants.DB_NAME, { useNewUrlParser: true })
db = mongoose.connection
db.on('error', console.error.bind(console, 'connection error:'))

pluginLoader = require('./plugin-reader').loadPlugin

#apis
ApiBaseController = require('./controller/api_base_controller')
SocketIoBaseController = require('./controller/socket_io_base_controller')
controllers = pluginLoader('./controller/user', (r)->
  # nullが設定されているやつは共通クラスなので初期化しない
  if r.ENTRYPOINT == null
    return
  obj = new r()
  if obj instanceof ApiBaseController
    obj.init(app, r.ENTRYPOINT)
  else if obj instanceof SocketIoBaseController
    obj.init(io, r.ENTRYPOINT)
)