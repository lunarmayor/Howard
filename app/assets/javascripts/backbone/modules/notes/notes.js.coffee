Howard.module "Notes", (Notes, App) ->

  class Notes.Router extends Marionette.AppRouter
    appRoutes:
      ""	: "setupDefaultList"
  API =
    setupDefaultList: ->
      Notes.List.Controller.showDefaultNotes()


  App.addInitializer ->
    new Notes.Router
      controller: API