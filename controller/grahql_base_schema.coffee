class GrahqlBaseSchema
  build:(schemaComposer)->
    [query,mutation,subscription] = @OnDefineSchema(schemaComposer)
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

  OnAuth: (rp)->
    return Promise.resolve(true)

  RegistorWarpResolver: (resolvers)=>
    Object.keys(resolvers).forEach((k) =>
      fn = (next) => (rp) =>
          result = await @OnAuth(rp)
          if result == false
            throw new Error('You should auth to have access to this action')
          parsed_rp = await @OnParseResolver(rp)
          payload = await @OnParsePayload(await next(parsed_rp))
          return payload
      if typeof resolvers[k].wrapResolve == 'function'
        resolvers[k] = resolvers[k].wrapResolve(fn)
    )
    return resolvers

module.exports = GrahqlBaseSchema
