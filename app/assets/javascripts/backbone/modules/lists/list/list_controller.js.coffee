Howard.module 'Lists.List', (List, App) ->

  List.Controller =
    showLists: ->
      lists = new List.View({collection: @getLists()})
      App.sidePaneRegion.show(lists)


    getLists: ->
      App.request('list:entities')
