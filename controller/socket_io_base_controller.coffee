class SocketIoBaseController
  @ENTRYPOINT = '/'
  constructor: (io,name)->
    namespace = io.of(name)
    namespace.use((socket, next) =>
      if @onAuth(socket.handshake.query)
        return next()
      return next(new Error('authentication error'))
    ).on('connection', (socket) =>
      console.log 'connected'
      @onConnect namespace,socket
    )

  onConnect: (namespace,socket)->
    return

  onAuth: (query)->
    return true

module.exports = SocketIoBaseController
