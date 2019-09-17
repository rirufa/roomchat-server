class GrahqlBaseSchema
  build:(schemaComposer)->
    composeWithMongoose = require('graphql-compose-mongoose').composeWithMongoose
    [query,mutation] = @OnDefineSchema(composeWithMongoose)
    schemaComposer.Query.addFields(@RegistorWarpResolver(query))
    schemaComposer.Mutation.addFields(@RegistorWarpResolver(mutation))
    return schemaComposer
   
  OnDefineSchema: (cm)->
   return sc

  OnParseResolver: (rp)->
    return rp

  OnParsePayload: (payload)->
    return payload

  RegistorWarpResolver: (resolvers)=>
    Object.keys(resolvers).forEach((k) =>
      fn = (next) => (rp) =>
          parsed_rp = @OnParseResolver(rp)
          payload = @OnParsePayload(await next(parsed_rp))
          return payload
      resolvers[k] = resolvers[k].wrapResolve(fn)
    )
    return resolvers

module.exports = GrahqlBaseSchema
