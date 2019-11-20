express = require('express')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)
PORT = process.env.PORT or 8080
http.listen PORT, ->
  console.log 'server listening. Port:' + PORT
  return

# allow cors
cors = require('cors')
app.use cors() 

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

#GraphQL
schemaComposer = require('graphql-compose').schemaComposer
ApolloServer = require('apollo-server-express').ApolloServer
GrahqlBaseSchema = require('./controller/grahql_base_schema')
LoginService = require('./service/login_service')
pluginLoader('./controller/schema', (r)->
  if r.name.indexOf('Base') == -1
    item = new r()
    schemaComposer = item.build(schemaComposer)
)
schema = schemaComposer.buildSchema()
server = new ApolloServer({
  schema: schema ,
  graphiql: true ,
  context:({req, connection} )=>
    if connection
      return connection.context
    headers = req.headers
    token = headers["x-access-token"]
    decoded = await LoginService.verify token
    return authed: decoded != null
})
server.applyMiddleware({ app, path: '/graphql' })
server.installSubscriptionHandlers(http)

#apis
ApiBaseController = require('./controller/api_base_controller')
SocketIoBaseController = require('./controller/socket_io_base_controller')
controllers = pluginLoader('./controller/user', (r)->
  # null���ݒ肳��Ă����͋��ʃN���X�Ȃ̂ŏ��������Ȃ�
  if r.ENTRYPOINT == null
    return
  obj = new r()
  if obj instanceof ApiBaseController
    obj.init(app, r.ENTRYPOINT)
  else if obj instanceof SocketIoBaseController
    obj.init(io, r.ENTRYPOINT)
)