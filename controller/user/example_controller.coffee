AuthBaseController = require('./auth_base_controller')

class ExampleController extends AuthBaseController
  @ENTRYPOINT = '/api/v1/example'

  onGetAsync: (req,res)->
    Promise.resolve({value: "example"}) 

module.exports = ExampleController