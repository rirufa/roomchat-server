RoomModel = require('../../model/room')
UserModel = require('../../model/user')
GrahqlAuthBaseSchema = require('./graphql_auth_base_schema')

class RoomSchema extends GrahqlAuthBaseSchema
  OnDefineSchema: (composeWithMongoose)->
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

    query = {
        roomById: Room.getResolver('findById'),
        roomByIds: Room.getResolver('findByIds'), 
        roomOne: Room.getResolver('findOne'), 
        roomMany: Room.getResolver('findMany'), 
        roomCount: Room.getResolver('count'), 
        roomConnection: Room.getResolver('connection'), 
        roomPagination: Room.getResolver('pagination') 
    }

    mutation = {
        roomCreate: Room.getResolver('createOne'), 
        roomCreateMany: Room.getResolver('createMany'), 
        roomUpdateById: Room.getResolver('updateById'), 
        roomUpdateOne: Room.getResolver('updateOne'), 
        roomUpdateMany: Room.getResolver('updateMany'), 
        roomRemoveById: Room.getResolver('removeById'), 
        roomRemoveOne: Room.getResolver('removeOne'), 
        roomRemoveMany: Room.getResolver('removeMany') 
    }
    return [query,mutation]

module.exports = RoomSchema