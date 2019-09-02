ApiBaseController = require('../api_base_controller')
UserModel = require('../../model/user')

class UserController extends ApiBaseController
  @ENTRYPOINT = '/api/v1/user'
  onGetAsync: (req,res)->
    req_param = req.body
    if typeof req_param.id == "undefined"
      users = await UserModel.get_all()
    else
      users = await UserModel.get({id:req_param.id})
    return {
      sucess: true,
      content: users
    }

  onPostAsync: (req,res)->
    req_param = req.body
    user = await UserModel.add({userid:req_param.userid, password:req_param.password, name:req_param.name , description:req_param.description})
    return {
      sucess: true
      content: user
    } 

module.exports = UserController