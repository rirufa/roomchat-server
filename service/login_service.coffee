UserModel = require('../model/user')

class LoginService
  superSecret = "oauthServerSampleSecret" #TODO
  @auth:(id,password)=>
    jwt = require "jsonwebtoken"
    result = await UserModel.auth({userid:id, password:password})
    if result.sucess
      user = result.content
      token = jwt.sign({userid:user.userid}, superSecret,{expiresIn: "24h"})
      return {token: token,id: user.id}
    else
      return null

  @verify: (token)=>
    if !token?
      return Promise.resolve(null)

    jwt = require "jsonwebtoken"
    jwt.verify token, superSecret, (err, decoded) =>
      if err
        return Promise.resolve(null)
      return Promise.resolve(decoded)

module.exports = LoginService