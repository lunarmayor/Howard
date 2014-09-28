Howard.module "List", (List, App) ->

  class List.Router extends Marionette.AppRouter
    appRoutes:
      ""	: "setupDefaultList"

  API =
    setupDefaultList: ->
      List.Graph.Controller.setupDefaultList()


  App.addInitializer ->
    new List.Router
      controller: API