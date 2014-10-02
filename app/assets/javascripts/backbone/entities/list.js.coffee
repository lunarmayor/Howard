Howard.module "Entities", (Entities, App) ->

	class Entities.List extends Entities.Model
      urlRoot: 'lists'

	class Entities.ListCollection extends Entities.Collection
	  url: 'lists'
	  model: Entities.List

	API = 
      getLists: ->
      	lists = new Entities.ListCollection()
      	lists.fetch()
      	lists

    App.reqres.setHandler "list:entities", API.getLists
