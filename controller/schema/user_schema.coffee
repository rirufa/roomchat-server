UserModel = require('../../model/user')
GrahqlBaseSchema = require('../grahql_base_schema')

class UserSchema extends GrahqlBaseSchema
  OnDefineSchema: (schemaComposer,composeWithMongoose)->
    # パスワードは外部に見せない
    customizationOptions = {
      fields: {
        remove: ['password'],
      }
    }
    User = composeWithMongoose(UserModel.get_schema(), customizationOptions);

    schemaComposer.Query.addFields({
        userById: User.getResolver('findById'),
        userByIds: User.getResolver('findByIds'), 
        userOne: User.getResolver('findOne'), 
        userMany: User.getResolver('findMany'), 
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
