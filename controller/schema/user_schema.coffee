UserModel = require('../../model/user')
GrahqlBaseSchema = require('../grahql_base_schema')

class UserSchema extends GrahqlBaseSchema
  OnParseResolver: (rp)->
    # パスワードを外部に出すとまずいので消す
    delete rp.projection.password
    return Promise.resolve(rp)
  OnDefineSchema: (schemaComposer)->
    UserTC = schemaComposer.createObjectTC("
      type User{
        id:ID,
        userid: String,
        password:String,
        name: String,
        description: String
    }")
    UserTC.addResolver({
      kind: 'query',
      name: 'findByID',
      args: {
        filter: "input UserFilterInput {
          id: String!
        }",
      },
      type: UserTC,
      resolve: ({ args, context }) =>
        return await UserModel.get({id:args.filter.id})
      ,
    })
    UserTC.addResolver({
      kind: 'query',
      name: 'findByIDs',
      args: {
        filter: "input UserFilterInput {
          ids: [String!]
        }",
      },
      type: [UserTC],
      resolve: ({ args, context }) =>
        return await UserModel.get_by_ids({ids:args.filter.ids})
      ,
    })
    UserTC.addResolver({
      kind: 'query',
      name: 'findMany',
      args: {
        limit: {
          type: 'Int',
          defaultValue: 20,
        },
        skip: 'Int',
      },
      type: [UserTC],
      resolve: ({ args, context }) =>
        return await UserModel.get_limit(args.limit, args.skip)
      ,
    })
    UserTC.addResolver({
      kind: 'mutation',
      name: 'createOne',
      args: {
        record: "input UserRecordInput{
          userid: String!,
          password:String!,
          name: String,
          description: String
        }"
      }
      type: UserTC,
      resolve: ({ args, context }) =>
        return await UserModel.add(args.record)
      ,
    })

    query = {
        userByID: UserTC.getResolver('findByID'),
        userMany: UserTC.getResolver('findMany'),
    }

    mutation = {
        userCreate: UserTC.getResolver('createOne'), 
    }
    return [query,mutation]

module.exports = UserSchema
