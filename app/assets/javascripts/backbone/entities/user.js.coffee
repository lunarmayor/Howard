Howard.module "Entities", (Entities, App) ->

	class Entities.User extends Entities.Model
      urlRoot: '/users'

	API =  
    getCurrentUser: ->
      user = new Entities.User()
      user.set('id', 1)
      user.fetch()

  App.reqres.setHandler "currentUser:entity", API.getCurrentUser


