class ApiBaseController
  @ENTRYPOINT = null
  init:(router,name)->
    router.get(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      @onGetAsync(req,res).then((param)->
        res.send(param)
      )
    )
    router.post(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      @onPostAsync(req,res).then((param)->
        res.send(param)
      )
    )
    router.put(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      @onPutAsync(req,res).then((param)->
        res.send(param)
      )
    )
    router.delete(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      @onDeleteAsync(req,res).then((param)->
        res.send(param)
      )
    )
    router.patch(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      @onPatchAsync(req,res).then((param)->
        res.send(param)
      )
    )
  verifyApi: (req,res,next)=>
    @onAuthAsync(req.body, req.query, req.headers).then((result)=>
      if result == true
        next()
      else
        res.send(@onAuthFailed())
    )
  onAuthAsync: (body, query, headers)->
    Promise.resolve(true)
  onAuthFailed: ()->
    return {message:"require auth or auth failed"}
  onGetAsync: (req,res)->
    Promise.resolve({})
  onPostAsync: (req,res)->
    Promise.resolve({})
  onPutAsync: (req,res)->
    Promise.resolve({})
  onDeleteAsync: (req,res)->
    Promise.resolve({})
  onPatchAsync: (req,res)->
    Promise.resolve({})

module.exports = ApiBaseController

