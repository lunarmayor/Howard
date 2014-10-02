Howard.module "Lists", (Lists, App) ->

  class Lists.Router extends Marionette.AppRouter
    appRoutes:
      ""	: "setupLists"
  API =
    setupLists: ->
      Lists.List.Controller.showLists()


  App.addInitializer ->
    new Lists.Router
      controller: API

    API.setupLists()