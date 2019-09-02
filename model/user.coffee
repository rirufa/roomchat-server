# get mongoose.Schema
mongoose = require 'mongoose'
Schema = mongoose.Schema


class UserModel
  UserSchema = new Schema({userid: String, password:String, name: String, description: String})
  User = mongoose.model('User', UserSchema)

  @auth: (param)->
   user = await User.findOne({userid: param.userid}).exec()
   return user.userid == param.userid && user.password == param.password

  @get_all: ()->
   users = await User.find({}).exec()
   return ({id:user.id, userid:user.userid, name:user.name, description:user.description} for user in users)

  @get: (param)->
   if !mongoose.Types.ObjectId.isValid(param.id)
     return {}
   user = await User.findById(param.id).exec()
   if user == null
     return {}
   else
     return {userid:user.userid, name:user.name, description:user.description}

  @add: (param)->
   item = new User({userid:param.userid, password:param.password, name:param.name ,description:param.description})
   await item.save()

module.exports = UserModel
