Howard.module "Lists", (Lists, App) ->

  class Lists.Router extends Marionette.AppRouter
    appRoutes:
      ""	: "setupLists"
      'lists/:id': 'showList'
      'lists': 'index'

  API =
    setupLists: ->
      Lists.List.Controller.showLists()

    showList: (id) ->
      Lists.List.Controller.showList(id)

    index: ->
      Lists.List.Controller.listIndex()

  App.addInitializer ->
    router = new Lists.Router(controller: API)
    API.setupLists() if window.location.pathname != '/config'

    App.commands.setHandler('show:list', (id) -> router.navigate('/lists/' + id, {trigger: true}))
    App.commands.setHandler('index:list', -> router.navigate('/lists', {trigger: true}))
    App.commands.setHandler('visit:root', API.setupLists)