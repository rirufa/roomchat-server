UserModel = require('../../model/user')
GrahqlBaseSchema = require('../grahql_base_schema')

class UserSchema extends GrahqlBaseSchema
  OnDefineSchema: (schemaComposer,composeWithMongoose)->
    User = composeWithMongoose(UserModel.get_schema(), {});

    # パスワードを外部に出すとまずいので消す
    removePasswordResolver = (next) => (rp) =>
      delete rp.projection.password
      payload = await next(rp)
      console.log payload
      return payload

    schemaComposer.Query.addFields({
        userById: User.getResolver('findById').wrapResolve(removePasswordResolver),
        userByIds: User.getResolver('findByIds').wrapResolve(removePasswordResolver), 
        userOne: User.getResolver('findOne').wrapResolve(removePasswordResolver), 
        userMany: User.getResolver('findMany').wrapResolve(removePasswordResolver),
        userCount: User.getResolver('count'), 
        userConnection: User.getResolver('connection'), 
        userPagination: User.getResolver('pagination') 
    })

    schemaComposer.Mutation.addFields({
        userCreate: User.getResolver('createOne'), 
        userCreateMany: User.getResolver('createMany'), 
        userUpdateById: User.getResolver('updateById'), 
        userUpdateOne: User.getResolver('updateOne'), 
        userUpdateMany: User.getResolver('updateMany'), 
        userRemoveById: User.getResolver('removeById'), 
        userRemoveOne: User.getResolver('removeOne'), 
        userRemoveMany: User.getResolver('removeMany') 
    })
    return schemaComposer

module.exports = UserSchema
