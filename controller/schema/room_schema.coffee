RoomModel = require('../../model/room')
UserModel = require('../../model/user')
GrahqlBaseSchema = require('../grahql_base_schema')

class RoomSchema extends GrahqlBaseSchema
  OnDefineSchema: (schemaComposer,composeWithMongoose)->
    Room = composeWithMongoose(RoomModel.get_schema(), {});
    User = composeWithMongoose(UserModel.get_schema(), {});

    Room.addRelation(
      'users',
      {
        resolver: () => User.getResolver('findByIds'),
        prepareArgs: {
          _ids: (source) =>source.users
        },
        projection: { users: 1 },
      }
    )

    schemaComposer.Query.addFields({
        roomById: Room.getResolver('findById'),
        roomByIds: Room.getResolver('findByIds'), 
        roomOne: Room.getResolver('findOne'), 
        roomMany: Room.getResolver('findMany'), 
        roomCount: Room.getResolver('count'), 
        roomConnection: Room.getResolver('connection'), 
        roomPagination: Room.getResolver('pagination') 
    })

    schemaComposer.Mutation.addFields({
        roomCreate: Room.getResolver('createOne'), 
        roomCreateMany: Room.getResolver('createMany'), 
        roomUpdateById: Room.getResolver('updateById'), 
        roomUpdateOne: Room.getResolver('updateOne'), 
        roomUpdateMany: Room.getResolver('updateMany'), 
        roomRemoveById: Room.getResolver('removeById'), 
        roomRemoveOne: Room.getResolver('removeOne'), 
        roomRemoveMany: Room.getResolver('removeMany') 
    })
    return schemaComposer

module.exports = RoomSchema