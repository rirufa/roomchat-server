ApiBaseController = require('../api_base_controller')
LoginService = require('../../service/login_service')

class AuthApiBaseController extends ApiBaseController
  @ENTRYPOINT = null
  decoded = null

  onAuthAsync: (body, query, headers)=>
     token = body.token || query.token || headers["x-access-token"]
     decoded = await LoginService.verify(token)
     if decoded == null
       return Promise.resolve(false)
     else
       @decoded = decoded
       return Promise.resolve(true)

module.exports = AuthApiBaseController