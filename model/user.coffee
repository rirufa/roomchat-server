# get mongoose.Schema
mongoose = require 'mongoose'
Schema = mongoose.Schema


class UserModel
  UserSchema = new Schema({userid: String, password:String, name: String, title: String})
  User = mongoose.model('User', UserSchema)

  @auth: (param)->
   user = await User.findOne({userid: param.userid}).exec()
   return user.userid == param.userid && user.password == param.password

  @get: (param)->
   user = await User.findOne({userid: param.userid}).exec()
   return user

  @add: (param)->
   item = new User({userid:param.userid, password:param.password, title:param.title})
   await item.save()

module.exports = UserModel
