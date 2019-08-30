ApiBaseController = require('../api_base_controller')
UserModel = require('../../model/user')

class LoginController extends ApiBaseController
  @ENTRYPOINT = '/api/v1/login'
  @superSecret = "oauthServerSampleSecret" #TODO
  onPostAsync: (req,res)->
    jwt = require "jsonwebtoken"
    req_param = req.body
    result = await UserModel.auth({userid:req_param.userid, password:req_param.password})
    if result
      user = await UserModel.get({userid:req_param.userid})
      token = jwt.sign(user.toJSON(), LoginController.superSecret,{expiresIn: "24h"})
      return {
        sucess: true,
        message: "Authentication successfully finished.",
        token: token
      } 
    else
      return {
        sucess: false,
        message: "Authentication failed",
      } 


module.exports = LoginController