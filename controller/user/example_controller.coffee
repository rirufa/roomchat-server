ApiBaseController = require('../api_base_controller')

class ExampleController extends ApiBaseController
  @ENTRYPOINT = '/api/v1/example'
  onGet: (req,res)->
    return {value: "example"} 

module.exports = ExampleController