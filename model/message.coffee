# get mongoose.Schema
mongoose = require 'mongoose'
Schema = mongoose.Schema

class MessageModel
  MessageSchema = new Schema({roomid:Number, senderid:Number, timestamp:Date ,content:String})
  Message = mongoose.model('Message', MessageSchema)

  @get_all: (param)->
   texts = await Message.find({roomid:param.roomid}).exec()
   return ({roomid:text.roomid, senderid:text.senderid, timestamp:text.timestamp, content:text.content} for text in texts)

  @add: (param)->
   today = new Date()
   item = new Message({roomid:param.roomid, senderid:param.senderid, timestamp:today, content:param.content})
   text = await item.save()
   return {roomid:text.roomid, senderid:text.senderid, content:text.content}

module.exports = MessageModel
