ApiBaseController = require('../api_base_controller')
UserModel = require('../../model/user')

class UserController extends ApiBaseController
  @ENTRYPOINT = '/api/v1/user'
  onGetAsync: (req,res)->
    req_param = req.body
    user = await UserModel.get({userid:req_param.userid})
    return {
      sucess: true,
      content: {userid:user.userid, name:user.name, description:user.description}
    }

  onPostAsync: (req,res)->
    req_param = req.body
    await UserModel.add({userid:req_param.userid, password:req_param.password, name:req_param.name , description:req_param.description})
    return {
      sucess: true
    } 

module.exports = UserController