SocketIoBaseController = require('../socket_io_base_controller')

class ChatController extends SocketIoBaseController
  @ENTRYPOINT = '/api/v1/chat-stream'
  onConnect: (chat,socket)->
    socket.on 'send', (msg) ->
      chat.emit 'receive', msg
    return

module.exports = ChatController
