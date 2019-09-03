class ApiBaseController
  @ENTRYPOINT = null
  init:(router,name)->
    router.get(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      @onGetAsync(req,res).then((param)->
        res.send(param)
      ).catch((e)=>
        res.send(@onError(e))
      )
    )
    router.post(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      @onPostAsync(req,res).then((param)->
        res.send(param)
      ).catch((e)=>
        res.send(@onError(e))
      )
    )
    router.put(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      @onPutAsync(req,res).then((param)->
        res.send(param)
      ).catch((e)=>
        res.send(@onError(e))
      )
    )
    router.delete(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      @onDeleteAsync(req,res).then((param)->
        res.send(param)
      ).catch((e)=>
        res.send(@onError(e))
      )
    )
    router.patch(name, @verifyApi, (req,res,next)=>
      res.header 'Content-Type', 'application/json; charset=utf-8'
      @onPatchAsync(req,res).then((param)->
        res.send(param)
      ).catch((e)=>
        res.send(@onError(e))
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
    return {success: false, error:"require auth or auth failed"}
  onError: (e)->
    return {success: false, error:"invaild request"}
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

