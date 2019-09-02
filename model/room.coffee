# get mongoose.Schema
mongoose = require 'mongoose'
Schema = mongoose.Schema

class RoomModel
  RoomSchema = new Schema({name:String,description:String,users:[{id:Number}]})
  Room = mongoose.model('Room', RoomSchema)

  @get_all: ()->
   rooms = await Room.find({}).exec()
   return ({id:room.id, name:room.name, description:room.description,users:room.users} for room in rooms)

  @get: (param)->
   if !mongoose.Types.ObjectId.isValid(param.id)
     return {}
   room = await Room.findById(param.id).exec()
   if room == null
     return {}
   else
     return {id:room.id, name:room.name, description:room.description,users:room.users}

  @add: (param)->
   item = new Room({name:param.name ,description:param.description ,users:param.users})
   await item.save()

module.exports = RoomModel
