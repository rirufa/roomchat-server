ApiBaseController = require('../api_base_controller')
LoginController = require('./login_controller')

class AuthBaseController extends ApiBaseController
  @ENTRYPOINT = null
  decoded = null

  onAuthAsync: (body, query, headers)=>
     token = body.token || query.token || headers["x-access-token"]
     # validate token
     if !token
       Promise.resolve(false)

     jwt = require "jsonwebtoken"
     jwt.verify token, LoginController.superSecret, (err, decoded) =>
       if err
         Promise.resolve(false)
       @decoded = decoded
       Promise.resolve(true)

module.exports = AuthBaseController