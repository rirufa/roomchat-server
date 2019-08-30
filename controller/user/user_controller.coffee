ApiBaseController = require('../api_base_controller')
UserModel = require('../../model/user')

class UserController extends ApiBaseController
  @ENTRYPOINT = '/api/v1/user'
  onPostAsync: (req,res)->
    req_param = req.body
    await UserModel.add({userid:req_param.userid, password:req_param.password, title:req_param.title})
    return {
      sucess: true
    } 

module.exports = UserController