RoomModel = require('../../model/room')
GrahqlBaseSchema = require('../grahql_base_schema')

class RoomSchema extends GrahqlBaseSchema
  OnDefineSchema: (schemaComposer,composeWithMongoose)->
    Room = composeWithMongoose(RoomModel.get_schema(), {});

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