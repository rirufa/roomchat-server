AuthApiBaseController = require('./auth_api_base_controller')

class ExampleController extends AuthApiBaseController
  @ENTRYPOINT = '/api/v1/example'

  onGetAsync: (req,res)->
    Promise.resolve({value: "example"}) 

module.exports = ExampleController