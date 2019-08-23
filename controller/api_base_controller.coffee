class ApiBaseController
  @ENTRYPOINT = '/'
  constructor:(router,name)->
    router.get(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      param = @onGet(req,res)
      res.send(param)
    )
    router.post(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      param = @onPost(req,res)
      res.send(param)
    )
    router.put(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      param = @onPut(req,res)
      res.send(param)
    )
    router.delete(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      param = @onDelete(req,res)
      res.send(param)
    )
    router.patch(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      param = @onPatch(req,res)
      res.send(param)
    )
  verifyApi: (req,res,next)=>
    if(@onAuth(req.body, req.query, req.headers))
      next()
    else
      res.send(@onAuthFailed())
  onAuth: (body, query, headers)->
    return true
  onAuthFailed: ()->
    return {"message":"require auth or auth failed"}
  onGet: (req,res)->
    return {}
  onPost: (req,res)->
    return {}
  onPut: (req,res)->
    return {}
  onDelete: (req,res)->
    return {}
  onPatch: (req,res)->
    return {}

module.exports = ApiBaseController

