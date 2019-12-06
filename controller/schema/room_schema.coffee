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
      kind: 'query',
      name: 'findMany',
      args: {
        limit: {
          type: 'Int',
          defaultValue: 20,
        },
        skip: 'Int',
      },
      type: [RoomTC],
      resolve: ({ args, context }) =>
        return await RoomModel.get_limit(args.limit, args.skip)
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
    RoomTC.addRelation(
      'users',
      {
        resolver: () => schemaComposer.getAnyTC("User").getResolver("findByIDs"),
        prepareArgs: {
          filter: (source) => {ids:source.users},
        },
        projection: { senderid: 1 },
      }
    )

    query = {
        roomByRoomID: RoomTC.getResolver('findByRoomID'),
        roomMany: RoomTC.getResolver('findMany'),
    }

    mutation = {
        roomCreateOne: RoomTC.getResolver('createOne'), 
    }
    return [query,mutation]

module.exports = RoomSchema