Howard.module "Notes", (Notes, App) ->

  class Notes.Router extends Marionette.AppRouter
    appRoutes:
      ""	: "setupDefaultList"
  API =
    setupDefaultList: ->
      Notes.List.Controller.showDefaultNotes()


  App.addInitializer ->
    router = new Notes.Router(controller: API)

    App.commands.setHandler('visit:root', -> router.navigate('/', {trigger: true}))