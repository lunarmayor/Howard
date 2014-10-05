Howard.module 'Lists.List', (List, App) ->

  List.Controller =
    showLists: ->
      lists = new List.View({collection: @getLists()})
      App.sidePaneRegion.show(lists)

    showList: (id) ->
      promise = App.request('list:entity', id)
      $.when(promise).then((list) ->
        list = new App.Entities.List(list)
        notes = new App.Entities.NoteCollection(list.attributes.notes)
        listView = new App.Notes.List.View({model: list, collection: notes})
        App.mainRegion.show(listView)
        App.reqres.setHandler('note:collection', -> listView.collection)
      )
      

    getLists: ->
      App.request('list:entities')

    getList: (id) ->
      App.request('list:entity', id)