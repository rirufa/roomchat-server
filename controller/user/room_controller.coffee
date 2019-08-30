ApiBaseController = require('../api_base_controller')
RoomModel = require('../../model/room')

class RoomController extends ApiBaseController
  @ENTRYPOINT = '/api/v1/room'
  onGetAsync: (req,res)->
    req_param = req.body
    if typeof req_param.id == "undefined"
      rooms = await RoomModel.get_all()
    else
      rooms = await RoomModel.get({id:req_param.id})
    return {
      sucess: true,
      content: rooms
    }

  onPostAsync: (req,res)->
    req_param = req.body
    await RoomModel.add({name:req_param.name , description:req_param.description})
    return {
      sucess: true
    } 

module.exports = RoomController