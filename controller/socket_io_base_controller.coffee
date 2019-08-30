class SocketIoBaseController
  @ENTRYPOINT = null
  init: (io,name)->
    namespace = io.of(name)
    namespace.use((socket, next) =>
      if @onAuth(socket.handshake)
        return next()
      return next(new Error('authentication error'))
    ).on('connection', (socket) =>
      console.log 'connected'
      @onConnect namespace,socket
    )

  onConnect: (namespace,socket)->
    return

  onAuth: (handshake)->
    return true

module.exports = SocketIoBaseController
