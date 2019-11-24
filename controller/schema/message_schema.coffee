MessageModel = require('../../model/message')
UserModel = require('../../model/user')
RoomModel = require('../../model/room')
GrahqlAuthBaseSchema = require('./graphql_auth_base_schema')
{ PubSub,withFilter } = require('apollo-server')

class MessageSchema extends GrahqlAuthBaseSchema
  OnDefineSchema: (schemaComposer)->
    MessageTC = schemaComposer.createObjectTC("
      type Message{
        roomid:String,
        senderid:String,
        timestamp:Date ,
        content:String
      }
    ")
    MessageTC.addRelation(
      'roomid',
      {
        resolver: () => schemaComposer.getAnyTC("Room").getResolver("findByRoomID"),
        prepareArgs: {
          filter: (source) => {id:source.roomid},
        },
        projection: { roomid: 1 },
      }
    )
    MessageTC.addRelation(
      'senderid',
      {
        resolver: () => schemaComposer.getAnyTC("User").getResolver("findByID"),
        prepareArgs: {
          filter: (source) => {id:source.senderid},
        },
        projection: { senderid: 1 },
      }
    )
    MessageTC.addResolver({
      kind: 'query',
      name: 'findManyByRoomID',
      args: {
        filter: "input MessageFilterInput {
          roomid: String
        }",
      },
      type: [MessageTC],
      resolve: ({ args, context }) =>
        return await MessageModel.get_all({roomid:args.filter.roomid})
      ,
    })
    pubsub = new PubSub()
    MESSAGE_ADDED = 'MESSAGE_ADDED'
    MessageTC.addResolver({
      kind: 'mutation',
      name: 'createOne',
      args: {
        record: "input MessageRecordInput{
          roomid:String,
          senderid:String,
          timestamp:Date,
          content:String
        }"
      },
      type: MessageTC,
      resolve: ({ args, context }) =>
        pubsub.publish(MESSAGE_ADDED, { messageAdded: args });
        return await MessageModel.add(args.record)
      ,
    })
    query = {
        messageById: MessageTC.getResolver('findManyByRoomID'),
    }

    mutation = {
        messageCreate: MessageTC.getResolver('createOne'), 
    }

    # subscribe‚¾‚¯ˆÈ‰º‚Ì‚æ‚¤‚É’è‹`‚µ‚È‚¢‚Æ“®‚©‚È‚¢
    # https://github.com/graphql-compose/graphql-compose-boilerplate
    subscription = {
        messageAdded:{
          type: MessageTC,
          resolve: (payload) =>
            return payload.messageAdded.record
          ,
          args: {
            filter: "input MessageAddedInput{
              roomid:String,
            }"
          },
          subscribe: withFilter(
            () => pubsub.asyncIterator('MESSAGE_ADDED'),
            (payload, variables) =>
              return payload.messageAdded.record.roomid == variables.filter.roomid
          )
        }
    }

    return [query,mutation,subscription]

module.exports = MessageSchema