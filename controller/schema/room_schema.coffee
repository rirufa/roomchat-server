RoomModel = require('../../model/room')
GrahqlAuthBaseSchema = require('./graphql_auth_base_schema')

class RoomSchema extends GrahqlAuthBaseSchema
  OnDefineSchema: (schemaComposer)->
    RoomTC = schemaComposer.createObjectTC("
      type Room{
        name:String,
        description:String,
        users:[String]
      }
    ")
    RoomTC.addResolver({
      kind: 'query',
      name: 'findByRoomID',
      args: {
        filter: "input RoomFilterInput {
          id: String
        }",
      },
      type: RoomTC,
      resolve: ({ args, context }) =>
        return await RoomModel.get({id:args.filter.id})
      ,
    })
    RoomTC.addResolver({
      kind: 'mutation',
      name: 'createOne',
      args: {
        record: "input RoomRecordInput{
          name:String!,
          description:String,
        }"
      },
      type: RoomTC,
      resolve: ({ args, context }) =>
        return await RoomModel.add(args.record)
      ,
    })

    query = {
        roomByRoomID: RoomTC.getResolver('findByRoomID'),
    }

    mutation = {
        roomCreateOne: RoomTC.getResolver('createOne'), 
    }
    return [query,mutation]

module.exports = RoomSchema