MessageModel = require('../../model/message')
UserModel = require('../../model/user')
RoomModel = require('../../model/room')
GrahqlAuthBaseSchema = require('./graphql_auth_base_schema')

class MessageSchema extends GrahqlAuthBaseSchema
  OnDefineSchema: (composeWithMongoose)->
    Message = composeWithMongoose(MessageModel.get_schema(), {});
    User = composeWithMongoose(UserModel.get_schema(), {});
    Room = composeWithMongoose(RoomModel.get_schema(), {});

    Message.addRelation(
      'roomid',
      {
        resolver: () => Room.getResolver('findById'),
        prepareArgs: {
          _id: (source) =>source.roomid
        },
        projection: { roomid: 1 },
      }
    )
    Message.addRelation(
      'senderid',
      {
        resolver: () => User.getResolver('findById'),
        prepareArgs: {
          _id: (source) =>source.senderid
        },
        projection: { senderid: 1 },
      }
    )

    query = {
        messageById: Message.getResolver('findById'),
        messageByIds: Message.getResolver('findByIds'), 
        messageOne: Message.getResolver('findOne'), 
        messageMany: Message.getResolver('findMany'), 
        messageCount: Message.getResolver('count'), 
        messageConnection: Message.getResolver('connection'), 
        messagePagination: Message.getResolver('pagination') 
    }

    mutation = {
        messageCreate: Message.getResolver('createOne'), 
        messageCreateMany: Message.getResolver('createMany'), 
        messageUpdateById: Message.getResolver('updateById'), 
        messageUpdateOne: Message.getResolver('updateOne'), 
        messageUpdateMany: Message.getResolver('updateMany'), 
        messageRemoveById: Message.getResolver('removeById'), 
        messageRemoveOne: Message.getResolver('removeOne'), 
        messageRemoveMany: Message.getResolver('removeMany') 
    }
    return [query,mutation]

module.exports = MessageSchema