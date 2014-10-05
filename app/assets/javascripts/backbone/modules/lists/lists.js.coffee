Howard.module "Lists", (Lists, App) ->

  class Lists.Router extends Marionette.AppRouter
    appRoutes:
      ""	: "setupLists"
      'lists/:id': 'showList'

  API =
    setupLists: ->
      Lists.List.Controller.showLists()

    showList: (id) ->
      Lists.List.Controller.showList(id)

  App.addInitializer ->
    router = new Lists.Router(controller: API)
    API.setupLists() if window.location.pathname != '/config'

    App.commands.setHandler('show:list', (id) -> router.navigate('/lists/' + id, {trigger: true}))