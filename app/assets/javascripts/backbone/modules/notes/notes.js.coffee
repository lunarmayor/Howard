Howard.module "Lists", (Lists) ->

  API =
    setupDefaultList: ->
      Lists.Graph.Controller.setupDefaultList()


  Lists.on 'start', ->
    API.setupDefaultList()