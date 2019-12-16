# get mongoose.Schema
mongoose = require 'mongoose'
Schema = mongoose.Schema


class UserModel
  UserSchema = new Schema({userid: String, password:String, name: String, description: String})
  User = mongoose.model('User', UserSchema)

  @get_schema: ()->
    return User

  @auth: (param)->
   user = await User.findOne({userid: param.userid}).exec()
   return {
    sucess:user.userid == param.userid && user.password == param.password,
    content: user}

  @get_all: ()->
   users = await User.find({}).exec()
   return ({id:user.id, userid:user.userid, name:user.name, description:user.description} for user in users)

  @get_limit: (limit,skip)->
   users = await User.find({}).limit(limit).skip(skip).exec()
   return ({id:user.id, userid:user.userid, name:user.name, description:user.description} for user in users)

  @get_by_ids: (param)->
   users = await User.find({}).where('_id').in(param.ids).exec()
   return ({id:user.id, userid:user.userid, name:user.name, description:user.description} for user in users)

  @get: (param)->
   user = await User.findById(param.id).exec()
   if user == null
     return {}
   else
     return {id: user.id, userid:user.userid, name:user.name, description:user.description}

  @add: (param)->
   item = new User({userid:param.userid, password:param.password, name:param.name ,description:param.description})
   user = await item.save()
   return {id: user.id, userid:user.userid, name:user.name, description:user.description}

module.exports = UserModel
