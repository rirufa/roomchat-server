class GrahqlBaseSchema
  build:(schemaComposer)->
    composeWithMongoose = require('graphql-compose-mongoose').composeWithMongoose
    @OnDefineSchema(schemaComposer, composeWithMongoose)
    return schemaComposer
   
  OnDefineSchema: (sc,cm)->
   return sc

module.exports = GrahqlBaseSchema
