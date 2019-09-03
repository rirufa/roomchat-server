AuthApiBaseController = require('./auth_api_base_controller')
MessageModel = require('../../model/message')

class DirectMessageController extends AuthApiBaseController
  @ENTRYPOINT = '/api/v1/direct_message'

  onGetAsync: (req,res)->
    req_param = req.body
    message = await MessageModel.get_all({roomid:req_param.roomid})
    return message

  onPostAsync: (req,res)->
    req_param = req.body
    text = await MessageModel.add({roomid:req_param.roomid, senderid:req_param.senderid, content:req_param.content})  
    return {
      sucess: true,
      content: text
    }

module.exports = DirectMessageController