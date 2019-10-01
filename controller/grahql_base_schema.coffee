class GrahqlBaseSchema
  build:(schemaComposer)->
    composeWithMongoose = require('graphql-compose-mongoose').composeWithMongoose
    [query,mutation,subscription] = @OnDefineSchema(composeWithMongoose)
    schemaComposer.Query.addFields(@RegistorWarpResolver(query))
    if mutation?
      schemaComposer.Mutation.addFields(@RegistorWarpResolver(mutation))
    if subscription?
      schemaComposer.Subscription.addFields(@RegistorWarpResolver(subscription))
    return schemaComposer
   
  OnDefineSchema: (cm)->
   return sc

  OnParseResolver: (rp)->
    return Promise.resolve(rp)

  OnParsePayload: (payload)->
    return Promise.resolve(payload)

  RegistorWarpResolver: (resolvers)=>
    Object.keys(resolvers).forEach((k) =>
      fn = (next) => (rp) =>
          parsed_rp = await @OnParseResolver(rp)
          payload = await @OnParsePayload(await next(parsed_rp))
          return payload
      resolvers[k] = resolvers[k].wrapResolve(fn)
    )
    return resolvers

module.exports = GrahqlBaseSchema
