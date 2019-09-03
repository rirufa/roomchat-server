class SocketIoBaseController
  @ENTRYPOINT = null
  init: (io,name)->
    namespace = io.of(name)
    namespace.use((socket, next) =>
      @onAuthAsync(socket.handshake).then((result)->
        if result
          return next()
        return next(new Error('authentication error'))
      )
    ).on('connection', (socket) =>
      console.log 'connected'
      @onConnect namespace,socket
    )

  onConnect: (namespace,socket)->
    return

  onAuthAsync: (handshake)->
    Promise.resolve(true)

module.exports = SocketIoBaseController
