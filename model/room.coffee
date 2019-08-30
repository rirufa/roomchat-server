# get mongoose.Schema
mongoose = require 'mongoose'
Schema = mongoose.Schema


class RoomModel
  RoomSchema = new Schema({name:String,description:String})
  Room = mongoose.model('Room', RoomSchema)

  @get_all: ()->
   rooms = await Room.find({}).exec()
   return ({id:room.id, name:room.name, description:room.description} for room in rooms)

  @get: (param)->
   room = await Room.findById(param.id).exec()
   return {id:room.id, name:room.name, description:room.description}

  @add: (param)->
   item = new Room({name:param.name ,description:param.description})
   await item.save()

module.exports = RoomModel
