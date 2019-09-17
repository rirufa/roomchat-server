UserModel = require('../../model/user')
GrahqlBaseSchema = require('../grahql_base_schema')

class UserSchema extends GrahqlBaseSchema
  OnParseResolver: (rp)->
    # パスワードを外部に出すとまずいので消す
    delete rp.projection.password
    return Promise.resolve(rp)
  OnDefineSchema: (composeWithMongoose)->
    User = composeWithMongoose(UserModel.get_schema(), {});

    query = {
        userById: User.getResolver('findById'),
        userByIds: User.getResolver('findByIds'), 
        userOne: User.getResolver('findOne'), 
        userMany: User.getResolver('findMany'),
        userCount: User.getResolver('count'), 
        userConnection: User.getResolver('connection'), 
        userPagination: User.getResolver('pagination') 
    }

    mutation = {
        userCreate: User.getResolver('createOne'), 
        userCreateMany: User.getResolver('createMany'), 
        userUpdateById: User.getResolver('updateById'), 
        userUpdateOne: User.getResolver('updateOne'), 
        userUpdateMany: User.getResolver('updateMany'), 
        userRemoveById: User.getResolver('removeById'), 
        userRemoveOne: User.getResolver('removeOne'), 
        userRemoveMany: User.getResolver('removeMany') 
    }
    return [query,mutation]

module.exports = UserSchema
