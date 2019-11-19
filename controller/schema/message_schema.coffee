MessageModel = require('../../model/message')
GrahqlAuthBaseSchema = require('./graphql_auth_base_schema')

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
        return await MessageModel.add(args.record)
      ,
    })

    query = {
        messageById: MessageTC.getResolver('findManyByRoomID'),
    }

    mutation = {
        messageCreate: MessageTC.getResolver('createOne'), 
    }
    return [query,mutation]

module.exports = MessageSchema