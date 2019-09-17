UserModel = require('../../model/user')
GrahqlBaseSchema = require('../grahql_base_schema')
LoginService = require('../../service/login_service')

class GraphqlAuthBaseSchema extends GrahqlBaseSchema
  OnParseResolver: (rp)->
     context = rp.context
     token = context.headers["x-access-token"]
     decoded = await LoginService.verify(token)
     if decoded == null
       throw new Error('You should auth to have access to this action')
     else
       return Promise.resolve(rp)

module.exports = GraphqlAuthBaseSchema
