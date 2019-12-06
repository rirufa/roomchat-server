# get mongoose.Schema
mongoose = require 'mongoose'
Schema = mongoose.Schema

class RoomModel
  RoomSchema = new Schema({name:String,description:String,users:[{ type: Schema.Types.ObjectId, ref: 'User' }]})
  Room = mongoose.model('Room', RoomSchema)

  @get_schema: ()->
    return Room

  @get_all: ()->
   rooms = await Room.find({}).exec()
   return ({id:room.id, name:room.name, description:room.description,users:room.users} for room in rooms)

  @get_limit: (limit,skip)->
   rooms = await Room.find({}).limit(limit).skip(skip).exec()
   return ({id:room.id, name:room.name, description:room.description,users:room.users} for room in rooms)

  @get: (param)->
   room = await Room.findById(param.id).exec()
   if room == null
     return {}
   else
     return {id:room.id, name:room.name, description:room.description, users:room.users}

  @add: (param)->
   item = new Room({name:param.name ,description:param.description ,users:param.users})
   room = await item.save()
   return {id:room.id, name:room.name, description:room.description,users:room.users}

module.exports = RoomModel
