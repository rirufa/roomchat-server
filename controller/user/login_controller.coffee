ApiBaseController = require('../api_base_controller')
UserModel = require('../../model/user')
LoginService = require('../../service/login_service')

class LoginController extends ApiBaseController
  @ENTRYPOINT = '/api/v1/login'
  onPostAsync: (req,res)->
    req_param = req.body
    result = await LoginService.auth(req_param.userid, req_param.password)
    if result != null
      return {
        sucess: true,
        message: "Authentication successfully finished.",
        content: result
      } 
    else
      return {
        sucess: false,
        message: "Authentication failed",
      } 


module.exports = LoginController