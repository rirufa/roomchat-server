LoginService = require('../../service/login_service')
GrahqlBaseSchema = require('../grahql_base_schema')

class UserAuthSchema extends GrahqlBaseSchema
  OnDefineSchema: (schemaComposer)->
    UserAuthTC = schemaComposer.createObjectTC("
      type UserAuth{
        sucess: Boolean,
        token: String,
        user: String,
    }")
    UserAuthTC.addRelation(
      'user',
      {
        resolver: () => schemaComposer.getAnyTC("User").getResolver("findByID"),
        prepareArgs: {
          filter: (source) => {id:source.user},
        },
        projection: { user: 1 },
      }
    )
    UserAuthTC.addResolver({
      kind: 'query',
      name: 'getToken',
      args: {
        filter: "input UserAuthInput {
          userid: String!
          password: String!
        }",
      },
      type: UserAuthTC,
      resolve: ({ args, context }) =>
        result = await LoginService.auth(args.filter.userid, args.filter.password)
        if result != null
          return {
            sucess: true,
            token: result.token,
            user: result.id
          } 
        else
          return {
            sucess: false,
            token: null,
            user: null
          } 
      ,
    })

    query = {
        userGetToken: UserAuthTC.getResolver('getToken'),
    }

    return [query]

module.exports = UserAuthSchema
