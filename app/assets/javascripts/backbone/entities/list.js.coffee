Howard.module "Entities", (Entities, App) ->

	class Entities.List extends Entities.Model
      urlRoot: '/lists'

	class Entities.ListCollection extends Entities.Collection
	  url: '/lists'
	  model: Entities.List

	API = 
      getLists: ->
      	lists = new Entities.ListCollection()
      	lists.fetch()
      	lists
      
      getList: (id) ->
        list = new Entities.List({id: id})
        list.fetch()

      getNewList: ->
        list = new Entities.List()

  App.reqres.setHandler "list:entities", API.getLists
  App.reqres.setHandler "list:entity", (id) -> API.getList(id)
  App.reqres.setHandler "new:list:entity", API.getNewList
