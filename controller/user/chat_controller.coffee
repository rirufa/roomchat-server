SocketIoBaseController = require('../socket_io_base_controller')
LoginService = require('../../service/login_service')
MessageModel = require('../../model/message')
RoomModel = require('../../model/room')

class ChatController extends SocketIoBaseController
  @ENTRYPOINT = '/api/v1/chat-stream'
  onAuthAsync: (handsake)=>
     token = handsake.query.token || handsake.headers["x-access-token"]
     decoded = await LoginService.verify(token)
     if decoded == null
       return Promise.resolve(false)
     else
       @decoded = decoded
       return Promise.resolve(true)
  onConnect: (chat,socket)->
    socket.on 'join', (msg) ->
      socket.join msg.roomid
    socket.on 'send', (msg) ->
      chat.to(msg.roomid).emit 'receive', msg
    socket.on 'sendall', (msg) ->
      chat.emit 'receive', msg
    return

module.exports = ChatController
