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
    socket.on 'join', (msg, cb) ->
      socket.join msg.roomid
      cb({sucess: true})
    socket.on 'fetchall', (msg, cb)->
      msgs = await MessageModel.get_all({roomid:msg.roomid})
      chat.to(msg.roomid).emit 'receive', msgs
      cb({sucess: true})
    socket.on 'send', (msg, cb) ->
      await MessageModel.add({roomid:msg.roomid, senderid:msg.senderid, content:msg.content})  
      chat.to(msg.roomid).emit 'receive', [msg]
      cb({sucess: true})
    socket.on 'sendall', (msg, cb) ->
      chat.emit 'receive', [msg]
      cb({sucess: true})
    return

module.exports = ChatController
