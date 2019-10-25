UserModel = require('../../model/user')
GrahqlBaseSchema = require('../grahql_base_schema')

class GraphqlAuthBaseSchema extends GrahqlBaseSchema
  OnAuth: (rp)->
    return Promise.resolve(rp.context.authed)

module.exports = GraphqlAuthBaseSchema
