Howard.module 'User', (User, App) ->

  class User.Router extends Marionette.AppRouter
  	appRoutes: 
  	  'config': 'editUser'
  
  API =
    editUser: ->
      User.Edit.Controller.editUser()

  App.addInitializer ->
  	router = new User.Router(controller: API)

  	App.commands.setHandler('visit:config', -> router.navigate('/config', {trigger: true}))